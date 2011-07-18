class Touch::Welcome::Index < Netzke::Base
  js_base_class "Ext.TabPanel"
  LoginPath = '/login.iphone'
  LogoutPath = '/logout.iphone'
  RegisterPath = '/register.iphone'

  def tab_item(contents,key)
    region_key= "#{key.to_s}__region".to_sym
    region= contents[region_key]
    return nil if region.nil?

    title_key= "#{key.to_s}__title".to_sym
    title= contents[title_key]
    title||= key.to_s.titleize

    return ( region.nil? ? nil : {
      :title => title,
      :cls => "#{key.to_s} transparent-class",
      :html => region
    } )
  end

  def tab_items(contents)
    [:message,:target,:main].map{ |key| tab_item(contents,key)}.compact
  end

  def self.netzke( view, config = {} )
    configr= Configurator.new(config,view)
    yield(configr) if block_given?
    config= configr.contents
    config[:class_name]= self
    config[:user_signed_in]= view.user_signed_in?
    return view.send(:netzke, :touch, config)
  end

  def public_toolbar_items
    [
      {:text => "Register", :handler => :to_register}
    ]
  end

  def user_toolbar_items
    [
     {:text => "Login", :handler => :to_login},
     {:text => "Logout", :handler => :to_logout}
    ]
  end

  def screen_config
    screen= Screen.default
    if screen.mode == :fullscreen
      { :fullscreen => true }
    else
      res= screen.device.resolution
      {
        :height => res[:height],
        :width => res[:width]
      }
    end
  end

  attr_accessor :configurator
  def configuration
    self.configurator= Configurator.new(session_config,nil)
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

  js_method :to_login_in, <<-JS
    function(){
      window.location="#{LoginPath}";
    }
  JS

  js_method :to_register, <<-JS
    function(){
      window.location="#{RegisterPath}";
    }
  JS

  js_method :to_logout, <<-JS
    function(){
      window.location="#{LogoutPath}";
    }
  JS

  endpoint :time_tracker_hello do |params|
    {:update => "Hello from LivingToLearn TimeTracker at #{Time.now}!"}
  end

end

