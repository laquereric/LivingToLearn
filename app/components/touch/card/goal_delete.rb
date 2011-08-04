class Touch::Card::GoalDelete < Touch::Tab::GoalPage
  js_base_class "Ext.form"

##########################
#
##########################

  js_method :deleteHandler, <<-JS
    function(button, event) {
      this.store.clearFilter();
      this.target.set( { name: 'destroyed' } );

      //Fails!
      //this.target.destroy({
      //  success: function() {
      //    console.log('The target was destroyed!');
      //  }
      //});

      console.log( this.store.getCount() );
      console.log(this.store);
    }
  JS


  def card_configuration
    {
      :items => [{
        :text => 'Delete',
        :xtype => :button,
        :handler => 'deleteHandler'
      }]
    }
  end

#############
# Main
#############

  js_method :init_card, <<-JS
    function(){
    }
  JS

end

