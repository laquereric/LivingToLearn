class Touch::Layouts::Application < Netzke::Base
  js_base_class "Ext.Panel"

  def self.template
    r= <<-HTML_ERB
<table style="border-width:2px">
  <tr>
<td><%= yield :message_region%></td>
  </tr>

  <tr>
<td><%= yield :target_region%></td>
  </tr>
</table>
  HTML_ERB

  end

  def self.netzke( view, config = {} )
    configr= Configurator.new(config,view)
    yield(configr) if block_given?
    config= configr.contents
    config[:class_name]= self
    return view.send(:netzke, :touch, config)
  end

  def top_toolbar_items
    [
      {:text => "Login", :handler => :to_sign_in},
      {:text => "Signup", :handler => :to_sign_up}
    ]
  end

  def configuration
    configurr= Configurator.new(session_config,nil)
    super.merge({
      :html => configurr.render(self.class.template),
      :docked_items => [
        {
          :dock => :top,
          :xtype => :toolbar,
          :title => session_config[:title].to_s,
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

