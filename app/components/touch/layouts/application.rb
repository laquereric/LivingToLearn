class Touch::Layouts::Application < Netzke::Base
  js_base_class "Ext.TabPanel"

  def self.netzke( view, config = {} )
    configr= Configurator.new(config,view)
    yield(configr) if block_given?
    config= configr.contents
    config[:class_name]= self
    return view.send(:netzke, :touch, config)
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

  def top_toolbar_items
    [
      {:text => "Login", :handler => :to_sign_in},
      {:text => "Signup", :handler => :to_sign_up}
    ]
  end

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

  def configuration
    contents= Configurator.new(session_config,nil).contents
    super.merge(self.screen_config).merge({
      :ui        => 'dark',
      :style => Screen.default.component_style,
      :items => self.tab_items(contents),
      :docked_items => [
        {
          :dock => :top,
          :xtype => :toolbar,
          :title => contents[:title].to_s,
        },
        {
          :dock => :bottom,
          :xtype => :toolbar,
          :ui   => 'light',
          :items => self.top_toolbar_items
        }
      ]
    })
  end

  js_method :to_sign_in, <<-JS
    function(){
      window.location='/users/sign_in.iphone';
    }
  JS

  js_method :to_sign_up, <<-JS
    function(){
      window.location='/sign_in/0.iphone';
    }
  JS

  endpoint :time_tracker_hello do |params|
    {:update => "Hello from LivingToLearn TimeTracker at #{Time.now}!"}
  end

end

