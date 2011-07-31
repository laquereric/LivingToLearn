class Touch::Tab::GoalsPage < Netzke::Base
  MaxChildren = 10
  extend NetzkeComponentExtend
  include NetzkeComponentInclude

  def parent_activity
    {
      :html => "Master"
    }
  end

   def target_activity
    {
      :html => "Activity"
    }
  end
###############
#
###############

  def list_instance( config = {} )
    list = Touch::Lib::NestedList.config_hash({
      :item_tpl => "=> {name} {level} {id} {parent_id}",
      :model => "Activity",
      :cls => 'list',
      :width => '100%',
      :height => 0
    })
  end

  def target_item( config = {} )
    config.merge({
      :cls => 'target_item'
    })
  end

  def self.child_item_ids
    (0..(MaxChildren-1)).map{ |i| "child_item_#{i}"}
  end

  def child_items( config = {} )
    self.class.child_item_ids.map{ |id|
      config.merge({
        :cls => id
      })
    }
  end

  def self.child_item_ids_js
    "#{self.child_item_ids.inspect}"
  end

  def parent_item( config = {} )
    config.merge({
      :cls => 'parent_item'
    });
  end

##############
#
###############
  def self.config_hash( session_config = {} )
     r = {}.merge( {:class_name => self.to_s } )
  end

  def configuration
    super.merge(self.screen_config).merge({
      :ui => 'dark',
      :style => Screen.default.component_style,
      :layout => {
          :type => 'fit'
      },
      :bodyCssClass => 'message',
      :items =>[{
        :baseCls => 'message',
        :scroll => 'vertical',
        :cls => 'transparent-class',
        :defaults => {
          :height => 40,
          :style => 'margin-top: 5px 0 0 0',
          :xtype => 'button',
          :width => '100%'
        },
        :layout => {
          :type => 'vbox',
          :pack => 'center'
        },
        :items =>[
          self.list_instance,
          {
            :item_tpl => "<== {name} {level} {id} {parent_id}"
          }.merge( self.parent_item ),
          {
            :item_tpl => "== {name} {level} {id} {parent_id}"
          }.merge( self.target_item ),
          child_items({
            :item_tpl => "==> {name} {level} {id} {parent_id}"
          })
        ].flatten
      }],
      :docked_items => [
        {
          :dock => :top,
          :xtype => :toolbar,
          :title => session_config[:title].to_s
        }
      ]
    })
  end

  js_method :get_list_cmp, <<-JS
    function(){
      var list_el = Ext.select('.list').elements[0];
      return Ext.getCmp(list_el.id);
    }
  JS

  js_method :init_component, <<-JS
    function(){
        #{js_full_class_name}.superclass.initComponent.call(this);
        this.on('activate', function() {
          var list_el = Ext.select('.list').elements[0];
          var listCmp =  Ext.getCmp(list_el.id);

          var parent_id = Ext.select('.parent_item').elements[0].id;
          listCmp.parent_id = parent_id;
          listCmp.parent_tpl =  Ext.getCmp(parent_id).itemTpl;

          var target_id = Ext.select('.target_item').elements[0].id;
          listCmp.target_id = target_id;
          listCmp.target_tpl = Ext.getCmp(target_id).itemTpl;

          listCmp.child_ids = #{child_item_ids_js};
          var child_0_id = Ext.select('.'+listCmp.child_ids[0]).elements[0].id;
          listCmp.child_tpl = Ext.getCmp(child_0_id ).itemTpl;

          listCmp.postInit();

          listCmp.setTargetEvents();
          listCmp.doClickEvent(-1);
          listCmp.on('totarget', function(target_id) {
console.log('totarget');
console.log(target_id);
          })

        });
    }
  JS

end

