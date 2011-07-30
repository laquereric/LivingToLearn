class Touch::Lib::NestedList < Netzke::Base
    js_base_class "Ext.List"

    extend NetzkeComponentExtend
    include NetzkeComponentInclude

    #js_mixin :main

    def self.config_hash(session_config)
       r = {}.merge( {:class_name => self.to_s
       } )

       r[:model]= session_config[:model]
       r[:item_tpl]= session_config[:item_tpl]
       r[:virtual_attrs]= session_config[:virtual_attrs]
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

    js_property :cursor
    js_method :set_cursor, <<-JS
      function(id){
        this.cursor = this.store.getById( id ).data;
        this.store.clearFilter();
        this.store.filter( 'parentId' , id );
     }
    JS

    js_method :set_click_event, <<-JS
      function(){
        this.on('itemtap', function(obj, index, list_item, e) {
          var rec = obj.store.getAt( index );
          var data = rec.data;
          this.setCursor( data.id );
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

        #{js_full_class_name}.superclass.initComponent.call(this);

        this.setClickEvent();
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

