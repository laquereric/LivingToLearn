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

  def self.netzke( view, page_ref="None", config = {} )
    config[:page_ref]= page_ref
    config[:title]= titlize_page_ref(page_ref)
    config[:class_name]= self
    yield(config) if block_given?
    return view.send(:netzke, :touch, config)
  end

  def configuration
    super.merge({
      :html => session_config[:html],
      :docked_items => [{:dock => :top, :xtype => :toolbar, :title => session_config[:title],
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

