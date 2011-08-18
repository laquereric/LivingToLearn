class Touch::Card::Goal::Delete < Touch::Tab::Goal
  js_base_class "Ext.form"

##########################
#
##########################

  js_method :deleteHandler, <<-JS
    function(button, event) {
      this.target.set( { name: 'destroyed' } );
      this.goBack();

      //Fails!
      //this.target.destroy({
      //  success: function() {
      //    console.log('The target was destroyed!');
      //  }
      //});

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

