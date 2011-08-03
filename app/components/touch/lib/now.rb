class Touch::Lib::Now < Netzke::Base
  js_base_class "Ext.Panel"
  extend NetzkeComponentExtend
  include NetzkeComponentInclude

  js_method :start, <<-JS
    function() {
      var current_time= new Date().getTime();
      this.start_time = current_time;
//console.log('oldElapsedSecs');
//console.log(this.oldElapsedSecs);
      this.running = true;
    }
  JS

  js_method :stop, <<-JS
    function() {
      this.old_elapsed_secs = this.elapsed_secs;
console.log('oldElapsedSecs');
console.log(this.old_elapsed_secs);
      this.running = false;
    }
  JS

  js_method :reset, <<-JS
    function() {
      this.old_elapsed_secs = 0;
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
  js_property :elapsed_time_formatted

  js_property :elapsed_secs
  js_property :new_elapsed_secs
  js_property :old_elapsed_secs

  js_method :elapsed_secs_update, <<-JS
    function() {
      var current_time= new Date().getTime();
      if (this.running){

console.log('oldElapsedSecs');
console.log(this.old_elapsed_secs);
        this.new_elapsed_secs = Math.round( (current_time-this.start_time) / 1000 );

console.log('newElapsedSecs');
console.log(this.new_elapsed_secs);
         this.elapsed_secs = this.new_elapsed_secs + this.old_elapsed_secs;

        if ( this.elapsed_secs < 60) {
          this.elapsed_time_formatted = this.elapsed_secs +' secs';
        } else if ( this.elapsed_secs < (60 * 60) ) {
          this.elapsed_time_formatted = this.formatFloat( this.elapsed_secs/60 ) +' min';
        } else {
          this.elapsed_time_formatted = this.formatFloat( this.elapsed_secs/(60*60) ) +' hr';
        }

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

  js_method :tick, <<-JS
    function(){
      this.currentTimeUpdate();
      this.elapsedSecsUpdate();
      this.fireEvent(
        'tick',
        this.current_time_formatted,
        this.elapsed_time_formatted,
        this.elapsed_secs
      );
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
      this.addEvents(
        'tick'
      );
      tick_targets[tick_targets.length] = this;
      this.start_time= new Date().getTime();
    }
  JS

end

