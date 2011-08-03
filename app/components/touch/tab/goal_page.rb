class Touch::Tab::GoalPage < Netzke::Base
  MaxChildren = 10
  extend NetzkeComponentExtend
  include NetzkeComponentInclude

###############
#
###############

  def self.config_hash( session_config = {} )
     r = {}.merge( {:class_name => self.to_s } )
  end

###########################
# Dynamic Configuration
###########################

  js_property :store
  js_property :target
  js_property :action_key
  js_property :action_title
  js_property :action_card

  js_property :elapsed_secs

###########################
#
###########################

  js_method :stopGoalHandler, <<-JS
    function(button, event) {
      this.getStartBtnCmp().show();
      this.getStopBtnCmp().hide();
      this.getNowCmp().stop();
    }
  JS

  js_method :startGoalHandler, <<-JS
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

  def doing_card
    return {
      :baseCls => 'message',
      :scroll => 'vertical',
      :cls => 'transparent-class goal start',
      :xtype => 'form',
      :defaults => {
        :width => '100%'
      },
      :layout => {
        :type => 'vbox'
      },
      :items => [
        clock_box,
        elapsed_box,
        stop_btn,
        start_btn
      ]
    }
  end

##########################
#
##########################

  js_method :editSubmitHandler, <<-JS
    function(button, event) {
      console.log('editSubmitHandler');
    }
  JS

  def edit_card
    return {
      :baseCls => 'message',
      :scroll => 'vertical',
      :cls => 'transparent-class goal edit',
      :xtype => 'form',
      :defaults => {
        :width => '100%'
      },
      :layout => {
        :type => 'vbox'
      },
      :items => [{
        :label => 'name',
        :xtype => :textfield
      },{
        :text => 'Submit',
        :xtype => :button,
        :handler => 'editSubmitHandler'
      }]
    }
  end

##########################
#
##########################
  js_method :addsubSubmitHandler, <<-JS
    function(button, event) {
      console.log('addsubSubmitHandler');
    }
  JS

  def addsub_card
    return {
      :baseCls => 'message',
      :scroll => 'vertical',
      :cls => 'transparent-class goal addsub',
      :xtype => 'form',
      :defaults => {
        :width => '100%'
      },
      :layout => {
        :type => 'vbox'
      },
      :items => [{
        :label => 'name',
        :xtype => :textfield
      },{
        :text => 'Add Sub Goal',
        :xtype => :button,
        :handler => 'addsubSubmitHandler'
      }]
    }
  end

##########################
#
##########################

  js_method :deleteHandler, <<-JS
    function(button, event) {
      this.store.clearFilter();
      console.log( this.store.getCount() );
      console.log('deleteHandler for id:' + this.target.id );

      var rec = this.store.getById(this.target.id);
      this.store.remove(rec);

      console.log( this.store.getCount() );
      console.log(this.store);
    }
  JS

  def delete_card
    return {
      :baseCls => 'message',
      :scroll => 'vertical',
      :cls => 'transparent-class goal delete',
      :xtype => 'form',
      :defaults => {
        :width => '100%'
      },
      :layout => {
        :type => 'vbox'
      },
      :items => [{
        :text => 'Delete Goal',
        :xtype => :button,
        :handler => 'deleteHandler'
      }]
    }
  end

##########################
#
##########################
  js_method :logTime, <<-JS
    function() {
      console.log('logTime');
      console.log( { target: this.target, elapsed_secs: this.elapsed_secs } 
      );
    }
  JS

#############
# Main
#############

  def configuration
    super.merge(self.screen_config).merge({
      :ui => 'dark',
      :style => Screen.default.component_style,
      :layout => {
          :type => 'card'
      },
      :bodyCssClass => 'message',
      :items =>[
         doing_card,
         edit_card,
         addsub_card,
         delete_card
      ],
      :docked_items => [
        {
          :dock => :top,
          :xtype => :toolbar,
          :title => 'Goal'
        },
        {
          :dock => :top,
          :height => 40,
          :html => 'this.target.name',
          :cls => 'goal target_item'
        },
        {
          :dock => :top,
          :height => 40,
          :html => 'this.action',
          :cls => 'goal action_item'
        }
      ]
    })
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

  js_method :init_component, <<-JS
    function(){

        #{js_full_class_name}.superclass.initComponent.call(this);
        var me = this;

        this.on('afterrender', function() {

          this.getNowCmp().on('tick', function(current_time,elapsed_time,elapsed_secs){
            me.elapsedSecs = elapsed_secs;

            var current_time_input= Ext.select( 'div.current_time input' ).elements[0];
            if (current_time_input) current_time_input.value = current_time;
            var elapsed_time_input= Ext.select( 'div.elapsed_time input' ).elements[0];
            if (elapsed_time_input) elapsed_time_input.value = elapsed_time;
          });

        });

        this.on('activate', function() {

          var target_item_el = Ext.select( 'div .goal.x-panel.target_item' ).elements[0];
          target_item_el.innerHTML = 'Selected: ' + me.target.name;

          var action_item_el = Ext.select( 'div .goal.x-panel.action_item' ).elements[0];
          action_item_el.innerHTML = 'Action: ' + me.actionTitle;

          me.actionCard = Ext.getCmp( Ext.select('.goal.' + me.actionKey ).elements[0].id );
          me.setActiveItem(me.actionCard);

          this.getStartBtnCmp().hide();
          this.getNowCmp().reset();
          this.getNowCmp().start();

        });

        this.on('deactivate', function() {
          this.getNowCmp().stop();
          this.logTime();
        });
    }
  JS

end

