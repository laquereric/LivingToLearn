class Touch::Tab::Goals < Netzke::Base
  MaxChildren = 10
  extend NetzkeComponentExtend
  include NetzkeComponentInclude

###############
#
###############

  def self.config_hash( session_config = {} )
     r = {}.merge( {
       :class_name => self.to_s
     } )
  end

######################
# Navigation
######################

  def navigation_toolbar
    return {
          :cls => 'navigation_toolbar',
          :dock => :top,
          :xtype => :toolbar,
          :items => [
            {
              :cls => 'goal_start',
              :text => 'START',
              :action_key => 'start',
              :handler => 'targetHandler'
            },{
              :cls => 'goal_edit',
              :text => 'EDIT',
              :action_key => 'edit',
              :handler => 'targetHandler'
            },{
              :cls => 'goal_add_sub',
              :text => 'AddSUB',
              :action_key => 'addsub',
               :handler => 'targetOptHandler'
            },{
              :cls => 'goal_delete',
              :text => 'DELETE',
              :action_key => 'delete',
              :handler => 'targetHandler'
            }
          ]
    }
  end

  def list_instance( config = {} )
    list = Touch::Lib::NestedList.config_hash({
      :item_tpl => "=> {name} {level} {id} {parent_id}",
      :model => "Activity",
      :cls => 'list',
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
        :cls => id,
        :margin => '0 0 5 20',
        #:style => '{padding-bottom:10;}'
        #:style => '{border:10;}'
      })
    }
  end

  def self.child_item_ids_js
    "#{self.child_item_ids.inspect}"
  end

  def parent_item( config = {} )
    config.merge({
       :margin => '0 0 5 0',
       :cls => 'parent_item'
    });
  end

  js_property :target

  js_method :get_list_cmp, <<-JS
    function(){
      var list_el = Ext.select('.list').elements[0];
      return Ext.getCmp(list_el.id);
    }
  JS

  js_method :get_main_cmp, <<-JS
    function(){
      var main_el = Ext.select( '.main' ).elements[0];
      return Ext.getCmp(main_el.id);
    }
  JS

  js_method :get_tab, <<-JS
    function(tab_cls){
      var tab_el = Ext.select( '.goal.' + tab_cls ).elements[0];
      var cmp = Ext.getCmp( tab_el.id );
      return cmp;
    }
  JS

  js_method :goto_goal_tab_action, <<-JS
    function(target,button){
      var main_cmp = this.getMainCmp();
      var goal_tab = this.getTab( button.actionKey );

      goal_tab.target = this.target;
      goal_tab.actionTitle = button.text;
      goal_tab.store = this.store;

      main_cmp.setActiveItem( goal_tab );
    }
  JS

######################
# Navigation Action
#######################

  js_method :targetOptHandler, <<-JS
    function(button, event) {
      this.gotoGoalTabAction( this.target, button );
    }
  JS

  js_method :targetHandler, <<-JS
    function(button, event) {
      if (this.target)
        this.targetOptHandler(button, event);
    }
  JS

#############
# Main
#############

  def configuration
    super.merge(self.screen_config).merge({
      :ui => 'dark',
      :cls => 'goals',
      :style => Screen.default.component_style,
      :scroll => false,
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
          :xtype => 'button',
          :width => '90%'
        },
        :layout => {
          :type => 'vbox',
          :defaultMargins => {:top=>100, :right=>100, :bottom=>100, :left=>100},
          :pack => 'center'
        },
        :items =>[
          self.list_instance,
          {
            :item_tpl => "<== {name} {level} {id} {parent_id}"
          }.merge( self.parent_item ),
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
        },
        {
          :dock => :top,
          :height => 40,
          :item_tpl => "Selected: {name} {level}"
        }.merge( self.target_item ),
        navigation_toolbar,
        {
          :cls => 'navigation_pane',
          :html=> 'Other Goals:'
        }
      ]
    })
  end

  js_method :init_component, <<-JS
    function(){
        #{js_full_class_name}.superclass.initComponent.call(this);
        this.on('activate', function() {
          var list_el = Ext.select('.list').elements[0];
          var listCmp =  Ext.getCmp(list_el.id);

          listCmp.parent_id = Ext.select('.parent_item').elements[0].id;
          listCmp.parent_tpl =  Ext.getCmp(listCmp.parent_id).itemTpl;

          listCmp.target_id = Ext.select('.target_item').elements[0].id;
          listCmp.target_tpl = Ext.getCmp(listCmp.target_id).itemTpl;

          listCmp.child_ids = #{child_item_ids_js};
          var child_0_id = Ext.select('.'+listCmp.child_ids[0]).elements[0].id;
          listCmp.child_tpl = Ext.getCmp(child_0_id ).itemTpl;

          listCmp.postInit();

          listCmp.setTargetEvents();
          listCmp.doClickEvent(-1);
          var me = this;
          listCmp.on('settarget', function(target) {
            me.target = target;
          })

        });
    }
  JS

end

