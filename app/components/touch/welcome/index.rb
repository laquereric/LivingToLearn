class Touch::Welcome::Index < Netzke::Base
  js_base_class "Ext.Panel"

  def configuration
    super.merge({
      :docked_items => [{:dock => :top, :xtype => :toolbar, :title => 'LivingToLearn',
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

