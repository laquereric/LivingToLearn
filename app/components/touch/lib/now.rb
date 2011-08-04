class Touch::Lib::Now < Netzke::Base
  js_base_class "Ext.Panel"
  extend NetzkeComponentExtend
  include NetzkeComponentInclude

  js_method :start, <<-JS
    function() {
      var current_time= new Date().getTime();
      this.startTime = current_time;
      this.running = true;
    }
  JS

  js_method :stop, <<-JS
    function() {
      this.oldElapsedSecs = this.elapsedSecs;
      this.running = false;
    }
  JS

  js_method :reset, <<-JS
    function() {
      this.oldElapsedSecs = 0;
    }
  JS

  js_property :running

###############
#
###############

  def self.config_hash( session_config = {} )
     r = {}.merge( {:class_name => self.to_s } )
  end

#################

  def configuration
    super
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

  js_property :elapsedTimeFormatted

  js_property :elapsedSecs
  js_property :newElapsedSecs
  js_property :oldElapsedSecs

  js_method :elapsedSecsUpdate, <<-JS
    function() {
      var current_time= new Date().getTime();
      if (this.running){

        this.newElapsedSecs = Math.round( (current_time-this.startTime) / 1000 );

        this.elapsedSecs = this.newElapsedSecs + this.oldElapsedSecs;

        if ( this.elapsedSecs < 60) {
          this.elapsedTimeFormatted = this.elapsedSecs +' secs';
        } else if ( this.elapsedSecs < (60 * 60) ) {
          this.elapsedTimeFormatted = this.formatFloat( this.elapsedSecs/60 ) +' min';
        } else {
          this.elapsedTimeFormatted = this.formatFloat( this.elapsedSecs/(60*60) ) +' hr';
        }

      }
    }
  JS

##########

  js_property :currentTimeFormatted
  js_method :currentTimeUpdate, <<-JS
    function() {
      this.currentTimeFormatted = new Date().format('g:i A');
    } 
  JS

##########

  js_method :tick, <<-JS
    function(){
      this.currentTimeUpdate();
      this.elapsedSecsUpdate();
      this.fireEvent(
        'tick',
        this.currentTimeFormatted,
        this.elapsedTimeFormatted,
        this.elapsedSecs
      );
    }
  JS

##########

  js_method :stpBtnHandler, <<-JS
    function(button, event) {
      window.location= this.stopPath;
    } 
  JS

  js_property :startTime
  js_method :initComponent, <<-JS
    function(){
      // calling superclass's initComponent
      #{js_full_class_name}.superclass.initComponent.call(this);
      this.addEvents(
        'tick'
      );
      tick_targets[tick_targets.length] = this;
      this.startTime= new Date().getTime();
    }
  JS

end

