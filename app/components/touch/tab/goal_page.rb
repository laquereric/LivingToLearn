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

  js_property :target

#############
# Main
#############

  def self.configure_cards
    [
       {
         :cls => 'transparent-class goal start'
       }.merge( Touch::Card::GoalStart.config_hash ),
       {
         :cls => 'transparent-class goal edit'
       }.merge( Touch::Card::GoalEdit.config_hash ),

       {
         :cls => 'transparent-class goal addsub'
       }.merge( Touch::Card::GoalAddsub.config_hash ),

       {
         :cls => 'transparent-class goal delete'
       }.merge( Touch::Card::GoalDelete.config_hash ),

    ]
  end

  def configuration
    super.merge(self.screen_config).merge({
      :ui => 'dark',
      :style => Screen.default.component_style,
      :layout => {
          :type => 'vbox'
      },
      :bodyCssClass => 'message',
      :items => [
         self.card_configuration[:items]
      ].flatten,
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
          :cls => 'goal target-item'
        },
        {
          :dock => :top,
          :height => 40,
          :html => 'this.action',
          :cls => 'goal action-item'
        }
      ]
    })
  end

  js_method :init_component, <<-JS
    function(){

        #{js_full_class_name}.superclass.initComponent.call(this);
        var me = this;

        this.on('activate', function() {

          Ext.each( Ext.select( 'div.x-panel.goal.target-item div.x-panel-body' ).elements, function(target_item_el) {
            if ( me.target ) {
              target_item_el.innerHTML = 'Selected: ' + me.target.data.name;
            } else {
              target_item_el.innerHTML = 'Selected: ' + 'Top';
            }
          });

          Ext.each( Ext.select( 'div.x-panel.goal.action-item div.x-panel-body' ).elements, function(action_item_el){
            action_item_el.innerHTML = 'Action: ' + me.actionTitle;
          });

        });

        this.initCard();

    }
  JS

end

