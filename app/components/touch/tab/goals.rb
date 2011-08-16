class Touch::Tab::Goals < Netzke::Base
  MaxChildren = 10
  extend NetzkeComponentExtend
  include NetzkeComponentInclude

###############
#
###############
  def self.config_hash_public(session_config)
    return {
      :html => "Please press 'User' then 'Register' to create an account"
    }
  end

  def self.config_hash_private(session_config)
    return {
      :user_id => session_config[:current_user].id,
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
          :defaultMargins => {:top => 100, :right => 100, :bottom => 100, :left => 100},
          :pack => 'center'
        },
        :items =>[
          self.list_instance(session_config),
          {
            #:item_tpl => "<== {name} {level} {id} {parent_id}"
            :item_tpl => "<== {name}"
          }.merge( self.parent_item ),
          self.child_items({
            #:item_tpl => "==> {name} {level} {id} {parent_id}"
            :item_tpl => "==> {name}"
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
          #:item_tpl => "Selected: {name} {level}"
          :item_tpl => "Selected: {name}"
        }.merge( self.target_item ),
        navigation_toolbar,
        {
          :cls => 'navigation_pane',
          :html=> 'Other Goals:'
        }
      ]
    }
  end

#########################
#
#########################

  def self.config_hash(session_config={})
    r = if session_config[:user_signed_in]
      config_hash_private(session_config)
    else
      config_hash_public(session_config)
    end
    r.merge!({:class_name => self.to_s })
    return r
  end

######################
# Navigation
######################

  def self.navigation_toolbar
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

  def self.get_data_set( data_class, session_config )
   return data_class.for_user( session_config[:current_user] )
  end

  def self.get_data( data_class, attrs, session_config )
   return get_data_set( data_class, session_config ).map{ |r| attrs.inject({}){|hsh,a| hsh.merge(a.to_sym => r.send(a))}}
  end

  def self.get_data_hash(session_config)
    attrs = [:id,:name,:level,:parent_id].map{|a| a.to_s }
    r= {
      :data => self.get_data( Activity, attrs, session_config ),
      :attrs => attrs.map{|a| a.camelize(:lower)}, # convert camelcase (more natural in JavaScript)
    }
    return r
  end

  def self.list_instance( session_config = {} )
    list = Touch::Lib::NestedList.config_hash({
      :item_tpl => "== Placeholder Only ==",
      :model => "Activity",
      :cls => 'list',
      :height => 0
    }).merge( self.get_data_hash(session_config) )
  end

  def self.target_item( config = {} )
    config.merge({
      :cls => 'target_item'
    })
  end

#############
#
#############

  def self.child_item_ids
    (0..(MaxChildren-1)).map{ |i| "child_item_#{i}"}
  end

  def self.child_items( config = {} )
    self.child_item_ids.map{ |id|
      config.merge({
        :cls => id,
        :margin => '0 0 5 20'
      })
    }
  end

  def self.child_item_ids_js
    "#{self.child_item_ids.inspect}"
  end

#############
#
#############

  def self.parent_item( config = {} )
    config.merge({
       :margin => '0 0 5 0',
       :cls => 'parent_item'
    });
  end

#############
#
#############

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
    su = super
    return su.merge(self.screen_config)
  end

  js_property :user_id

  js_method :init_component, <<-JS
    function(){
        #{js_full_class_name}.superclass.initComponent.call(this);
        if (this.initialConfig.userId){
          this.userId = this.initialConfig.userId;
          this.on('activate', function() {
            var list_el = Ext.select('.list').elements[0];
            var listCmp =  Ext.getCmp(list_el.id);
            listCmp.userId = this.userId;
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

    }
  JS

end

