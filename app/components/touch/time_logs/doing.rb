class Touch::TimeLogs::Doing < Netzke::Base
  js_base_class "Ext.Panel"
  extend NetzkeComponentExtend
  include NetzkeComponentInclude

  def top_box(title="")
    return  {
      :height => 80,
      :padding => '10px',
      :html => title
    }
  end

  def clock_box()
    return  {
      :padding => '10px',
      :baseCls => 'clock',
      :height => 100,
      :width => 140,
      :html =>"",
      :align => :center,
    }
  end

  def elapsed_box()
    return  {
       :padding => '10px',
        :baseCls => 'elapsed',
        :height => 100,
        :width => 200,
        :html=>"",
        :align => :center,
     }
  end

  def custom_panel(contents)
    original_tabs= self.tab_items(contents)
    title= "Doing #{contents[:activity_name]}"
    return {
      :layout => {
        :type => 'vbox',
        :align => 'center'
      },
      :items => [
        self.top_box(title),
        self.clock_box(),
        self.elapsed_box(),
      {
        :height => 100,
        :handler => 'stpBtnHandler',
        :xtype => 'button',
        :ui  => 'decline-round',
        :cls  => 'stopBtn',
        :text => 'STOP'
      }]
    }
  end

  def configuration
    self.class.route_toolbars if @toolbars_routed.nil?
    super.merge(self.screen_config).merge({
      :ui        => 'dark',
      :style => Screen.default.component_style,
      :docked_items => [
        {
          :dock => :top,
          :xtype => :toolbar,
          :title => session_config[:title].to_s
        },
        {
          :dock => :bottom,
          :xtype => :toolbar,
          :items => (session_config[:user_signed_in] ? self.user_toolbar_items : self.public_toolbar_items )
        }
      ]
    }).merge( custom_panel(session_config) )
  end

  js_method :tick, <<-JS
  function(){
    this.current_time= new Date().getTime();
    var ticks= Math.round( (this.current_time-this.start_time) /1000 );
    Ext.select('div.elapsed div').elements[0].innerHTML='Elapsed '+ ticks+' secs';
    Ext.select('div.clock div').elements[0].innerHTML= new Date().format('g : i A s');
  }
  JS

  js_property :start_time
  js_property :current_time

  js_method :stpBtnHandler, <<-JS
    function(button, event) {
        //alert('hh');
        window.location= this.stopPath;
        //alert('privVar1=' + privVar1);
        //alert('this.btn1Text=' + this.btn1Text);
    }
  JS


  js_method :init_component, <<-JS
    function(){
      // calling superclass's initComponent
      #{js_full_class_name}.superclass.initComponent.call(this);

      tick_targets[tick_targets.length] = this;
      this.start_time= new Date().getTime();
    }
  JS

end

