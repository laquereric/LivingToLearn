class Touch::Layouts::Application < Netzke::Base
  js_base_class "Ext.TabPanel"
  extend NetzkeComponentExtend
  include NetzkeComponentInclude

  def configuration
    self.class.route_toolbars if @toolbars_routed.nil?
    super.merge(self.screen_config).merge({
      :items => self.tab_items(session_config),
      :ui        => 'dark',
      :style => Screen.default.component_style,
      :docked_items => [
        {
          :dock => :top,
          :xtype => :toolbar,
          :title => session_config[:title].to_s
        },
        {
          :dock => :bottom,
          :xtype => :toolbar,
          :items => (session_config[:user_signed_in] ? self.user_toolbar_items : self.public_toolbar_items )
        }
      ]
    })
  end

end

