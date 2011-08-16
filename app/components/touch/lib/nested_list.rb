class Touch::Lib::NestedList < Netzke::Base
    js_base_class "Ext.List"

    extend NetzkeComponentExtend
    include NetzkeComponentInclude

    def self.config_hash(session_config={})
       r = session_config.merge( {
         :class_name => self.to_s
       } )
       return r
    end

    def configuration
      sup = super
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
          if ( parentNotDestroyed && ( i < child_items.length ) &&
             ( child_items[i].data.name != 'destroyed' ) ) {
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

############
# Adding
############

    js_method :nl_added, <<-JS
      function(msg){
        var rec = this.store.getById(-99);
        rec.set('id', parseInt(msg.id) );
        rec.dirty = false;
        rec.sent = false;
        rec.phantom = false;
      }
    JS

    endpoint :nl_add do |params|
      if params[:parent_id] and  params[:parent_id].length > 0
        parent_activity = Activity.find( params[:parent_id].to_i )
        activity = Activity.new
        activity.update_attributes( :name => params[:name], :parent_id => params[:parent_id].to_i )
        parent_activity.children << activity
      else
        activity = Activity.new
        activity.update_attributes( :name => params[:name], :parent_id => nil )
        activity.save
      end
      return { :nl_added => { :id => activity[:id] } }
    end

    js_method :nl_check_for_phantom, <<-JS
      function( store , scope){
        var nrs = store.getNewRecords();
        Ext.each( nrs,
          function(nr){
            if (nr.phantom && !nr.sent) {
                nr.set( 'id', -99);
                scope.nlAdd({
                id : nr.data.id ,
                name : nr.data.name,
                parent_id : nr.data.parentId
              });
              nr.sent = true;
            }
          }
        );
      }
    JS

############
# Destroying & Updating
############

    js_method :nl_destroyed, <<-JS
      function(msg){
        var rec = this.store.getById( parseInt(msg.id) );
        rec.dirty = false;
        rec.sent = false;
      }
    JS

    endpoint :nl_destroy do |params|
      activity = Activity.find(params[:id])
      activity.destroy
      { :nl_destroyed => { :id => params[:id] }  }
    end

    js_method :nl_updated, <<-JS
      function(msg){
        var rec = this.store.getById( parseInt(msg.id) );
        rec.dirty = false;
        rec.sent = false;
      }
    JS

    endpoint :nl_update do |params|
      activity = Activity.find(params[:id])
      activity.update_attributes( :name => params[:name], :parent_id => [:parentId] );
      { :nl_updated => params  }
    end

    js_method :nl_check_for_dirty, <<-JS
      function( store , scope ){
        var urs = store.getUpdatedRecords()
        Ext.each( urs,
          function(ur){
            if ( ur.dirty && !ur.sent && ur.data.id != -99 ){
              if ( ur.data.name == 'destroyed' ){
                scope.nlDestroy({
                  id : ur.data.id ,
                  name : ur.data.name,
                  parentId : ur.data.parentId
                });
                ur.sent = true;
              } else {
                scope.nlUpdate({
                  id : ur.data.id ,
                  name : ur.data.name,
                  parentId : ur.data.parentId
                });
                ur.sent = true;
              }
            }
          }
        );
      }
    JS

####################
#
#####################

    js_method :nl_data_changed, <<-JS
      function( store ){
        this.nlCheckForDirty(store,this);
        this.nlCheckForPhantom(store,this);
      }
    JS

####################
#
#####################

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
          autoLoad : false,
          remoteSort : false,
          getGroupString : function(record) {
            return record.get(sortAttr)[0];
          },
          data : this.data
        });

        #{js_full_class_name}.superclass.initComponent.call(this);
        this.addEvents(
          'totarget',
          'settarget'
        );
        this.store.filter( 'level' , 0 );
        this.store.on('datachanged',this.nlDataChanged,this)
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

