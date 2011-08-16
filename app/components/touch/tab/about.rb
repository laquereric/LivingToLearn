class Touch::Tab::About < Netzke::Base

  js_base_class "Ext.TabPanel"
  extend NetzkeComponentExtend
  include NetzkeComponentInclude

############################
# About Page - Public
############################

  def self.about_page_tabs_public(session_config)
    [{
       :title =>'Mission',
       :cls => 'mission',
       :scroll => :both,
       :html => <<-JS
We help your friends help you improve some part of your life.</br>
</br>
How do you do it?</br>
</br>
First, you identify some goal.</br>
</br>
Next you make a commitment to taking a step needed to move towards that goal.</br>
</br>
Then, you identify the friends (and others) who you want to help you to be accountable (your accountability partners).</br>
</br>
Whether you meet your commitment or not, your accountability partners are kept informed.</br>
</br>
This will work with the help of our service or without it. We just make it a little easier.</br>
</br>
See 'Vision' to learn more.
JS
    },{
      :title =>'Vision',
      :cls => 'vision',
      :scroll => :both,
      :html => <<-JS
You will begin moving to your goal in a matter of minutes! Please continue ...</br>
</br>
First, what type of goal do you want to pursue? Do you want an 'A' in Chemistry? Do you want to pray for 5 minutes a day?</br>
</br>
To proceed, register yourself (under User), describe your goal (under Goals), and then make some commitment towards achieving that goal (under commitments).</br>
</br>
Now is the most important part ... invite your friends to help you be accountable (under accountability).</br>
</br>
That's it! As we promised, you will be off and running very soon.
JS
    }
    ]
  end

  def self.config_hash_public(session_config)
      {
      :docked_items => [{
        :dock => :top,
        :xtype => :panel,
        :cls => :'top-tab-title',
        :html => 'Improve (part of) your life now!'
      }],
      :items =>  about_page_tabs_public(session_config),
      }
  end

######################################
#
######################################

  def self.about_page_tabs_private(session_config)
    [{
       :title =>'Mission',
       :cls => 'mission',
       :scroll => :vertical,
       :html => <<-JS
Welcome
JS
    },{
      :title =>'Vision',
      :cls => 'vision',
      :scroll => :vertical,
      :html => <<-JS
Welcome
JS
    }
    ]
  end

  def self.config_hash_private(session_config)
      {
      :docked_items => [{
        :dock => :top,
        :xtype => :panel,
        :cls => :'top-tab-title',
        :html => 'Improve (part of) your life now!'
      }],
      :xtype => :tabpanel,
      :items =>  about_page_tabs_private(session_config),
      }
  end

#########################
#
#########################

  def self.config_hash(session_config)
    r= if session_config[:user_signed_in]
      config_hash_private(session_config)
    else
      config_hash_public(session_config)
    end
    r.merge!({:class_name => self.to_s })
    return r
  end

  js_method :get_tab_scroller, <<-JS
    function(title){
      return Ext.select('div.x-panel.'+title+' div.x-scroller').elements[0];
    }
  JS

  js_method :get_tab_component, <<-JS
    function(title){
      var panel_el = Ext.select('div.x-panel.'+title).elements[0];
      return  Ext.getCmp(panel_el.id);
    }
  JS

  js_method :set_tab_zoom, <<-JS
    function(tabId,zoom){
      if ( zoom > 0 && zoom < 2) {
        var tabComp = this.getTabComponent(tabId);
        var tabScroller = this.getTabScroller(tabId);
        Ext.fly(tabScroller).setStyle( "zoom" , tabComp.current_zoom );
        Ext.fly(tabScroller).setSize(
          tabComp.initial_width * tabComp.current_zoom,
          tabComp.initial_height * tabComp.current_zoom
        );
      }
    }
  JS

  js_method :init_tab, <<-JS
    function(title){
        var body_el =  this.getTabScroller(title);
        var body_cmp = this.getTabComponent(title);
        body_cmp.current_zoom = 1.0;
        var dimensions = Ext.fly(body_el).getSize();
        body_cmp.initial_width = dimensions.width;
        body_cmp.initial_height = dimensions.height;
    }
  JS

  js_method :getTabIds, <<-JS
    function(){
      var me = this;
      var tabIds = new Array();
      var tabEls = Ext.select('div.about div.x-panel').elements;
      Ext.each( tabEls, function(tabEl){
        var classes = Ext.fly(tabEl).getAttribute('class');
        Ext.each( classes.split(' '), function(class){
          var hasLen = ( class.length > 0 );
          var isX = (class.slice(0,1) != 'x' && class.slice(1,2) != '-' );
          var isTop = (class.slice(0,3) != 'top');
          if (hasLen && isX && isTop) {
            tabIds.push(class);
          }
        } );
      });
      return tabIds;
    }
  JS

  js_method :setTabZoomable, <<-JS
    function( tabId ){
        var me = this;

        me.initTab(tabId);

        var mission_body_cmp = this.getTabComponent(tabId);
        var mission_body_el = this.getTabScroller(tabId);

        var factor = 0.3;

          Ext.fly(mission_body_el).on('pinch', function(e){
            if(e.deltaScale < 0){
                factor *= -1;
            }
            mission_body_cmp.current_zoom = mission_body_cmp.current_zoom * ( 1 + factor );
            me.setTabZoom(tabId,mission_body_cmp.current_zoom);
          });

          Ext.fly(mission_body_el).on('tap', function(e){
            if(e.deltaScale < 0){
                factor *= -1;
            }
            var newZoom = mission_body_cmp.current_zoom * ( 1 + factor );
            mission_body_cmp.current_zoom = newZoom;
            me.setTabZoom( tabId , mission_body_cmp.current_zoom );
          });
    }
  JS

  js_method :init_component, <<-JS
    function(){
      #{js_full_class_name}.superclass.initComponent.call(this);
      var me = this;
      this.on('cardswitch', function() {
        Ext.each( me.getTabIds(), function(tabId){
          var mission_body_cmp = me.getTabComponent(tabId);
          mission_body_cmp.current_zoom = 1.0;
          me.setTabZoom(tabId,mission_body_cmp.current_zoom);
        });
      });
      this.on('activate', function() {
        Ext.each( me.getTabIds(), function(tabId){
          me.setTabZoomable(tabId);
        });
      });
    }
  JS

end

