class Touch::Card::GoalStart < Touch::Tab::Goal

  js_property :elapsed_secs

###########################
#
###########################

  js_method :stop_goal_handler, <<-JS
    function(button, event) {
      this.getStartBtnCmp().show();
      this.getStopBtnCmp().hide();
      this.getNowCmp().stop();
      this.tellServer({ event: 'stop', activity: this.target.data });
    }
  JS

  js_method :start_goal_handler, <<-JS
    function(button, event) {
      this.getStartBtnCmp().hide();
      this.getStopBtnCmp().show();
      this.getNowCmp().start();
      this.tellServer({ event: 'start', activity: this.target.data });
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

  def server_box
    return {
      :label => 'server',
      :cls => :server,
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
    {
      :items => [
        server_box,
        clock_box,
        elapsed_box,
        stop_btn,
        start_btn
      ]
    }
  end

  js_method :get_now_cmp, <<-JS
    function(){
      var now_el = Ext.select( 'div.now' ).elements[0];
      return Ext.getCmp( now_el.id );
    }
  JS

  js_method :get_start_btn_cmp, <<-JS
    function(){
      var el = Ext.select( 'div.goal.start div.x-button.start' ).elements[0];
      return Ext.getCmp( el.id );
    }
  JS

  js_method :get_stop_btn_cmp, <<-JS
    function(){
      var el = Ext.select( 'div.goal.start div.x-button.stop' ).elements[0];
      return Ext.getCmp( el.id );
    }
  JS

  js_method :init_card, <<-JS
    function(){
        var me = this;
        this.on('activate', function() {

          var nowCmp = me.getNowCmp();
          if ( typeof nowCmp.events.tick != "undefined" &&
              nowCmp.events.tick &&
              nowCmp.events.tick == true ){
            nowCmp .on('tick', function(current_time,elapsed_time,elapsed_secs){
              me.elapsedSecs = elapsed_secs;
              var current_time_input = Ext.select( 'div.current_time input' ).elements[0];
              if (current_time_input) current_time_input.value = current_time;
              var elapsed_time_input = Ext.select( 'div.elapsed_time input' ).elements[0];
              if (elapsed_time_input) elapsed_time_input.value = elapsed_time;
            });
          }
        });

        this.on('activate', function() {

          me.getStartBtnCmp().hide();
          me.getNowCmp().reset();
          me.getNowCmp().start();

          me.tellServer({ event: 'init', activity: me.target.data });

        });

        this.on('deactivate', function() {

          me.getNowCmp().stop();
          me.tellServer({ event: 'done', activity: me.target.data });

        });
    }
  JS

########################
#
########################

  js_method :update_server_box, <<-JS
    function(msg){
      var el = Ext.select( 'div.x-field.server input' ).elements[0];
      el.value = msg
    }
  JS

  endpoint :register_event do |params|
    { :update_server_box => "Got #{params[:event]}" }
  end

  js_method :tell_server, <<-JS
    function(params){
      this.registerEvent(params);
    }
  JS

end

