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

###########################
#
###########################
  js_method :stopGoalHandler, <<-JS
    function(button, event) {
      console.log('stopGoalHandler');
    }
  JS

  def clock_box
    return {
      :label => 'clock',
      :xtype => :textfield
    }
  end

  def elapsed_box
    return {
      :label => 'elapsed',
      :xtype => :textfield
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
        {
          :text => 'Stop',
          :xtype => :button,
          :handler => 'stopGoalHandler'
        }
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

  js_method :init_component, <<-JS
    function(){
        #{js_full_class_name}.superclass.initComponent.call(this);
        var me = this;
        this.on('activate', function() {
          var target_item_el = Ext.select( 'div .goal.x-panel.target_item' ).elements[0];
          target_item_el.innerHTML = 'Selected: ' + me.target.name;

          var action_item_el = Ext.select( 'div .goal.x-panel.action_item' ).elements[0];
          action_item_el.innerHTML = 'Action: ' + me.actionTitle;

          me.actionCard = Ext.getCmp( Ext.select('.goal.' + me.actionKey ).elements[0].id );
          me.setActiveItem(me.actionCard);
        });
    }
  JS

end

