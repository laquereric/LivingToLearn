class Touch::TimeLogs::Doing < Netzke::Base
  js_base_class "Ext.Panel"
  extend NetzkeComponentExtend
  include NetzkeComponentInclude

  def top_box(contents)
    return  {
      :baseCls => 'header',
      :padding => '15px',
      :html => "Doing Activity:</br>#{contents[:activity_name]}",
    }
  end

  def clock_box(contents)
    return [{
      :html =>"Current Time"
    },{
      :baseCls => 'clock',
      :html =>"____________"
    }]
  end

  def elapsed_box(contents)
    return  [{
        :html=>"Elapsed Time"
     },{
        :baseCls => 'elapsed',
        :html=>"_____________"
     }]
  end

  def stop_button(contents)
    return  {
        :width => '100%',
        :handler => 'stpBtnHandler',
        :ui  => 'decline-round',
        :cls  => 'stopBtn',
        :text => 'STOP'
    }
  end

#################

  def configuration
    self.class.route_toolbars if @toolbars_routed.nil?
    super.merge(self.screen_config).merge({
      :ui => 'dark',
      :style => Screen.default.component_style,
      :layout => {
          :type => 'fit'
      },
      :bodyCssClass => 'message',
      :items =>[{
        :baseCls => 'message',
        :cls => 'transparent-class',
        :defaults => {
          :height => 40,
          :style => 'margin-top: 5px 0 0 0'
        },
        :layout => {
          :type => 'vbox',
          :pack => 'center'
        },
        :items =>[
          clock_box(session_config),
          elapsed_box(session_config)
        ].flatten
      }],
      :docked_items => [
        {
          :dock => :top,
          :xtype => :toolbar,
          :title => session_config[:title].to_s
        },
        self.top_box(session_config).merge({
          :dock => :top,
          :xtype => :panel,
        }),
        {
          :dock => :bottom,
          :xtype => :toolbar,
          :items => (session_config[:user_signed_in] ? self.user_toolbar_items : self.public_toolbar_items )
        },
        {
          :dock => :bottom,
          :xtype => :toolbar,
          :items => [self.stop_button(session_config)]
        }
      ]
    })
  end

###########

  js_method :format_float, <<-JS
    function(par) {
      var str = new String(par);
      var subs = str.split('.');
      var int = subs[0];
      var ndp = "0000";

      if ( subs.length > 1 ){
        var ndp = subs[1].slice(0,3);
      }

      return int + '.' + ndp;
    }
  JS

##########

  js_property :elapsed_secs
  js_property :elapsed_time_formatted

  js_method :elapsed_secs_update, <<-JS
    function() {
      var current_time= new Date().getTime();

      this.elapsed_secs = Math.round( (current_time-this.start_time) /1000 );

      if ( this.elapsed_secs < 60) {
        this.elapsed_time_formatted = this.elapsed_secs +' secs';
      } else if ( this.elapsed_secs < (60 * 60) ) {
        this.elapsed_time_formatted = this.formatFloat( this.elapsed_secs/60 ) +' min';
      } else {
        this.elapsed_time_formatted = this.formatFloat( this.elapsed_secs/(60*60) ) +' hr';
      }

    }
  JS

##########

  js_property :current_time_formatted
  js_method :current_time_update, <<-JS
    function() {
      this.current_time_formatted = new Date().format('g:i A');
    } 
  JS

##########

  js_method :push_text, <<-JS
    function(button, event) {
      Ext.select('div.clock div').elements[0].innerHTML= this.current_time_formatted;
      Ext.select('div.elapsed div').elements[0].innerHTML= this.elapsed_time_formatted;
    } 
  JS

##########

  js_method :tick, <<-JS
    function(){
      this.currentTimeUpdate();
      this.elapsedSecsUpdate();
      this.pushText();
    }
  JS

##########

  js_method :stpBtnHandler, <<-JS
    function(button, event) {
      window.location= this.stopPath;
    } 
  JS

  js_property :start_time
  js_method :init_component, <<-JS
    function(){
      // calling superclass's initComponent
      #{js_full_class_name}.superclass.initComponent.call(this);

      tick_targets[tick_targets.length] = this;
      this.start_time= new Date().getTime();
    }
  JS

end

