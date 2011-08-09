Touch::User::RegisterForm
Touch::User::LoginForm

class Touch::Lib::Main < Netzke::Base

  js_base_class "Ext.TabPanel"
  extend NetzkeComponentExtend
  include NetzkeComponentInclude

  def configuration
    self.class.route_toolbars if @toolbars_routed.nil?
    super.merge(self.screen_config).merge({

      :items => self.tab_items(session_config),
      :cls => 'main',
      :ui => 'dark',

      :style => Screen.default.component_style,

      :tabBar => {
        :dock => 'bottom',
        :layout => {
          :pack => 'center'
        }
      },

     :cardSwitchAnimation => {
        :type => 'slide',
        :cover => true
     },

     :docked_items => [
        {
          :dock => :top,
          :xtype => :toolbar,
          :title => session_config[:title].to_s
        }
     ],

     :items =>  [

       {
         :title => 'About',
         :iconCls => 'info',
         :cls =>  'transparent-class about',
       }.merge(Touch::Tab::About.config_hash(session_config)),

       {
         :cls =>  'now'
       }.merge(Touch::Lib::Now.config_hash(session_config)),

       {
         :title => 'User',
         :cls => 'transparent-class user',
         :iconCls => 'user',
         :badgeText => 'Login?'
       }.merge( Touch::Tab::User.config_hash(session_config)),

       {
         :title => 'Goals',
         :cls => 'transparent-class goals',
         :iconCls => 'download'
       }.merge( Touch::Tab::Goals.config_hash ),

       Touch::Tab::Goal.configure_cards,

       {
         :title => 'Commitments',
         :cls =>  'transparent-class commitments',
         :iconCls => 'download'
       }.merge(Touch::Tab::Commitments.config_hash(session_config)),

       {
         :title => 'Accountability',
         :cls => 'transparent-class accountability',
         :iconCls => 'settings'
       }.merge(Touch::Tab::Accountability.config_hash(session_config))

     ].flatten

    })
  end

  js_method :init_component, <<-JS
    function(){
      #{js_full_class_name}.superclass.initComponent.call(this);
      this.on('afterrender', function() {
          var tab_els = Ext.select('.x-tab').elements;
          for ( var i = 0; i < tab_els.length; i++){
            if ( Ext.select('span',tab_els[i] ).elements.length == 0 ){
              var tabCmp =  Ext.getCmp(tab_els[i].id);
              this.tabBar.remove( Ext.getCmp(tab_els[i].id), true);
            }
          }
        })
    }
  JS

end

