class Touch::Lib::NestedList < Netzke::Base
    js_base_class "Ext.List"

    extend NetzkeComponentExtend
    include NetzkeComponentInclude

    #js_mixin :main

    def self.config_hash(session_config={})
       r = session_config.merge( {:class_name => self.to_s
       } )
       return r
    end

    def get_data( data_class, attrs )
      return data_class.all.map{ |r| attrs.inject({}){|hsh,a| hsh.merge(a.to_sym => r.send(a))}}
    end

    def configuration
      sup = super

      # extract model attributes that participate in the template
      attrs = [ extract_attrs(sup) , [:id,:level,:parent_id] ].flatten.uniq.map{|a| a.to_s }

      sup.merge!(
        :data => get_data( sup[:model].constantize , attrs ),
        :attrs => attrs.map{|a| a.camelize(:lower)}, # convert camelcase (more natural in JavaScript)
        :item_tpl => sup[:item_tpl].gsub(/\{(\w+)\}/){|m| m.camelize(:lower)}, # same here
        :sort_attr => (sup[:sort_attr] || attrs.first).to_s.camelize(:lower) # ... and here
      )

      return sup
    end

    js_property :target
    js_method :set_target, <<-JS
      function(id){

        this.store.clearFilter();

        if ( id > 0 ) {
          this.target = this.store.getById( id );

          this.store.filterBy( function(record) {
            var isChild = ( record.data.parentId == id );
            var notDestroyed = ( isChild && record.data.name != 'destroyed' )
            result = ( isChild && notDestroyed );
            return result;
          });
        } else {
          this.target = null;
          this.store.filterBy( function(record){
            var okType = ( (typeof record.data.parentId) == 'string' );
            var notDestroyed = ( okType && record.data.name != 'destroyed' )
            result = ( okType && notDestroyed );
            return result;
          } );
        }

        this.parent = null;
        if (this.target && this.target.data.parentId) {
          this.parent = this.store.getById( this.target.data.parentId );
        } else {
          this.parent = null;
        }

        var me= this;
        me.children = new Array;
          if ( this.store.getCount() >  0) {
            this.store.each(
              function(item){
                me.children.push(item);
                return true;
              }
            );
          }
      }
    JS

    js_property :parent
    js_property :children

    js_method :do_click_event, <<-JS
      function(id){
        if ( this.target && this.target.id == id ){
          this.fireEvent('totarget', id );
        } else {
          this.setTarget( id );
          this.fireEvent('settarget', this.target,this.parent,this.children);
        }
      }
    JS

  js_property :parent_id

  js_property :parent_el
  js_property :parent_cmp
  js_property :parent_tpl

  js_property :target_id

  js_property :target_el
  js_property :target_cmp

  js_property :child_ids

  js_property :child_els
  js_property :child_cmps

  js_method :post_init, <<-JS
    function(){
          var listCmp = this;

          listCmp.parent_el = Ext.select( '#' + listCmp.parent_id ).elements[0];
          listCmp.parent_cmp = Ext.getCmp( listCmp.parent_id );
          listCmp.parent_cmp.item_list = listCmp;
          if ( typeof listCmp.parent_cmp.events.tap != "undefined" &&
            listCmp.parent_cmp.events.tap &&
            listCmp.parent_cmp.events.tap == true ){
              listCmp.parent_cmp.addListener('tap', function(button,e){
                button.item_list.doClickEvent( button.item_id );
              });
          };
          if ( listCmp.parent_tpl == null ){
            listCmp.parent_tpl = '<= {name}';
          }
          listCmp.parent_template= new Ext.Template(listCmp.parent_tpl);
          listCmp.parent_template.compile();

          listCmp.target_el = Ext.select( '#' + listCmp.target_id ).elements[0];
          listCmp.target_cmp =  Ext.getCmp(listCmp.target_id);
          listCmp.target_cmp.item_list = listCmp;
          if ( typeof listCmp.target_cmp.events.tap != "undefined" &&
            listCmp.target_cmp.events.tap &&
            listCmp.target_cmp.events.tap == true ){
              listCmp.target_cmp.addListener('tap', function(button,e){
                button.item_list.doClickEvent( button.item_id );
              });
          };

          if ( listCmp.target_tpl == null ){
            listCmp.target_tpl = '= {name}';
          }
          listCmp.target_template = new Ext.Template( listCmp.target_tpl );
          listCmp.target_template.compile();

          listCmp.child_els = new Array;
          listCmp.child_cmps = new Array;
          listCmp.child_template = new Ext.Template('=> {name}');
          listCmp.child_template.compile();
          for( var i=0; i < listCmp.child_ids.length; i++ ){
            listCmp.child_els.push( Ext.select('.'+listCmp.child_ids[i] ).elements[0] );
            listCmp.child_cmps.push( Ext.getCmp( listCmp.child_els[i].id ) );
            listCmp.child_cmps[i].item_list = listCmp;
            if ( typeof listCmp.child_cmps[i].events.tap != "undefined" &&
              listCmp.child_cmps[i].events.tap &&
              listCmp.child_cmps[i].events.tap == true ){
                listCmp.child_cmps[i].addListener('tap', function(button,e){
                button.item_list.doClickEvent( button.item_id );
              });
            }
          }
          if ( listCmp.child_tpl == null ){
            listCmp.child_tpl = '=> {name}';
          }
          listCmp.child_template= new Ext.Template( listCmp.child_tpl );
          listCmp.child_template.compile();
    }
  JS

  js_method :set_target_events, <<-JS
    function(){
      var maxChildren = this.child_ids.length;
      var me = this;
      this.on('settarget', function(target_item, parent_item, child_items) {

///////////////////////
// Up Hier
///////////////////////
       var topList = false;
       if ( (target_item == null) && (parent_item == null) ){
          topList = true;
          me.parent_cmp.hide();
       } else if ( parent_item == null ) {
          topList = true;
          me.parent_el.innerHTML = '<=' +'Top';
          me.parent_cmp.show();
          me.parent_cmp.item_id = -1;
        } else  {
          me.parent_template.overwrite( me.parent_el, parent_item.data );
          me.parent_cmp.show();
          me.parent_cmp.item_id =  parent_item.data.id;
        }

///////////////////////
// At Level
///////////////////////

        if (target_item){
          me.target_cmp.show();
          me.target_cmp.item_id = target_item.data.id;
          me.target_template.overwrite( me.target_el, target_item.data );
        } else {
          me.target_cmp.hide();
        }

///////////////////////
// Down Level
///////////////////////

        var parentNotDestroyed = ( topList || ( target_item && target_item.data.name != 'destroyed' ));
        for( var i = 0; i < maxChildren; i++ ){
          //if ( parentNotDestroyed && ( i < child_items.length ) && ( child_items[i].data.name != 'destroyed' ) ) {
          if ( i < child_items.length ) {
            me.child_cmps[i].show();
            me.child_cmps[i].item_id = child_items[i].data.id;
            me.child_template.overwrite( me.child_els[i], child_items[i].data );
          } else {
            me.child_cmps[i].hide();
          }
        };

      });
    }
  JS

    js_method :init_component, <<-JS
      function(){
        Ext.regModel(this.model, {
          fields: this.attrs
        });

        var sortAttr = this.sortAttr;
        this.store = new Ext.data.JsonStore({
          model  : this.model,
          storeId : this.model + '_store',
          sorters: sortAttr,
          remoteFilter : false,
          remoteGroup : false,
          autoSync : false,
          autoLoad : false,
          remoteSort : false,
          getGroupString : function(record) {
            return record.get(sortAttr)[0];
          },
          data: this.data
        });
        this.store.filter( 'level' , 0 );

        #{js_full_class_name}.superclass.initComponent.call(this);
        this.addEvents(
          'totarget',
          'settarget'
        );
      }
    JS

    protected
      # Extracts names of the attributes from the temalpate, e.g.:
      # "{last_name}, ${salary}" =>
      # ["last_name", "salary"]
      def extract_attrs(config)
        config[:item_tpl].scan(/\{(\w+)\}/).map{ |m| m.first }
      end
  end

