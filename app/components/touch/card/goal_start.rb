class Touch::Card::GoalStart < Touch::Tab::GoalPage

  js_property :elapsed_secs

###########################
#
###########################

  js_method :stop_goal_handler, <<-JS
    function(button, event) {
      this.getStartBtnCmp().show();
      this.getStopBtnCmp().hide();
      this.getNowCmp().stop();
    }
  JS

  js_method :start_goal_handler, <<-JS
    function(button, event) {
      this.getStartBtnCmp().hide();
      this.getStopBtnCmp().show();
      this.getNowCmp().start();
    }
  JS

  def clock_box
    return {
      :label => 'clock',
      :cls => :current_time,
      :xtype => :textfield
    }
  end

  def elapsed_box
    return {
      :label => 'elapsed',
      :cls => :elapsed_time,
      :xtype => :textfield
    }
  end

  def stop_btn
    {
      :text => 'Stop',
      :cls => 'stop',
      :xtype => :button,
      :handler => 'stopGoalHandler'
    }
  end

  def start_btn
    {
      :text => 'Start',
      :cls => 'start',
      :xtype => :button,
      :handler => 'startGoalHandler'
    }
  end

#############
# Main
#############

  def card_configuration
    { :items => [
        clock_box,
        elapsed_box,
        stop_btn,
        start_btn
    ]}
  end

  js_method :get_now_cmp, <<-JS
    function(){
      var now_el = Ext.select( '.now' ).elements[0];
      return Ext.getCmp( now_el.id );
    }
  JS

  js_method :get_start_btn_cmp, <<-JS
    function(){
      var el = Ext.select( 'div.x-button.start' ).elements[0];
      return Ext.getCmp( el.id );
    }
  JS

  js_method :get_stop_btn_cmp, <<-JS
    function(){
      var el = Ext.select( 'div.x-button.stop' ).elements[0];
      return Ext.getCmp( el.id );
    }
  JS

  js_method :init_card, <<-JS
    function(){
console.log('ic');
        //#{js_full_class_name}.superclass.initComponent.call(this);
        var me = this;
        this.on('afterrender', function() {
console.log('ar');

          this.getNowCmp().on('tick', function(current_time,elapsed_time,elapsed_secs){
            me.elapsedSecs = elapsed_secs;
console.log('tick');
            var current_time_input= Ext.select( 'div.current_time input' ).elements[0];
            if (current_time_input) current_time_input.value = current_time;
            var elapsed_time_input= Ext.select( 'div.elapsed_time input' ).elements[0];
            if (elapsed_time_input) elapsed_time_input.value = elapsed_time;
          });

        });

        this.on('activate', function() {

          me.getStartBtnCmp().hide();
          me.getNowCmp().reset();
          me.getNowCmp().start();

        });

        this.on('deactivate', function() {
          this.getNowCmp().stop();
          this.logTime();
        });
    }
  JS

end

