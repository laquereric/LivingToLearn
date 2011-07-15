class Touch::Welcome::Index < Netzke::Base
  js_base_class "Ext.Panel"

  def self.titlize_page_ref(page_ref)
    m= page_ref.match(/(.*)#(.*)/)
    if m
      page_ref.gsub('#','_').titleize
    else
      page_ref
    end
  end

  def self.netzke( view, config = {} )
    configr= Configurator.new(config,view)
    yield(configr) if block_given?
    config= configr.contents
    config[:class_name]= self
    return view.send(:netzke, :touch, config)
  end

  def configuration
p session_config[:title]
    super.merge({
      :html => session_config[:html],
      :docked_items => [{:dock => :top, :xtype => :toolbar, :title => session_config[:title].to_s,
        :items => [
          {:text => "TimeTracker", :handler => :on_time_tracker}
        ]
      }]
    })
  end

  js_method :on_time_tracker, <<-JS
    function(){
      this.timeTrackerHello();
    }
  JS

  endpoint :time_tracker_hello do |params|
    {:update => "Hello from LivingToLearn TimeTracker at #{Time.now}!"}
  end

end

