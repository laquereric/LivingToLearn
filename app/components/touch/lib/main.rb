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
       }.merge(Touch::Lib::AboutPage.config_hash(session_config)),

       {
         :title => 'User',
         :cls => 'transparent-class user',
         :iconCls => 'user',
         :badgeText => 'Login?'
       }.merge( Touch::Lib::UserPage.config_hash(session_config)),

       {
         :title => 'Goals',
         :cls => 'transparent-class goals',
         :iconCls => 'download'
       }.merge(Touch::Lib::GoalsPage.config_hash(session_config)),

       {
         :title => 'Commitments',
         :cls =>  'transparent-class commitments',
         :iconCls => 'download'
       }.merge(Touch::Lib::CommitmentsPage.config_hash(session_config)),

       {
         :title => 'Accountability',
         :cls => 'transparent-class accountability',
         :iconCls => 'settings'
       }.merge(Touch::Lib::AccountabilityPage.config_hash(session_config))

     ]
    })
  end

end
