class Touch::Lib::SimpleList < Netzke::Base
    js_base_class "Ext.List"

    extend NetzkeComponentExtend
    include NetzkeComponentInclude

    #js_mixin :main

    def self.config_hash(session_config)
       r = {}.merge( {:class_name => self.to_s
       } )
       r[:model]= session_config[:model]
       r[:item_tpl]= session_config[:item_tpl]
       return r
    end

    def configuration
      sup = super

      # extract model attributes that participate in the template
      attrs = extract_attrs(sup)

      # model's class
      data_class = sup[:model].constantize

      sup.merge!(
        :data => data_class.all.map{ |r| attrs.inject({}){|hsh,a| hsh.merge(a.to_sym => r.send(a))}},
        :attrs => attrs.map{|a| a.camelize(:lower)}, # convert camelcase (more natural in JavaScript)
        :item_tpl => sup[:item_tpl].gsub(/\{(\w+)\}/){|m| m.camelize(:lower)}, # same here
        :sort_attr => (sup[:sort_attr] || attrs.first).to_s.camelize(:lower) # ... and here
      )
p sup
      return sup
    end

  js_method :init_component, <<-JS
    function(){
      Ext.regModel(this.model, {
          fields: this.attrs
      });

      var sortAttr = this.sortAttr;

      this.store = new Ext.data.JsonStore({
          model  : this.model,
          sorters: sortAttr,

          getGroupString : function(record) {
              return record.get(sortAttr)[0];
          },

          data: this.data
      });

      #{js_full_class_name}.superclass.initComponent.call(this);
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

