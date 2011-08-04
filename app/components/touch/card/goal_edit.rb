class Touch::Card::GoalEdit < Touch::Tab::GoalPage
  js_base_class "Ext.form"
##########################
#
##########################

  js_method :editSubmitHandler, <<-JS
    function(button, event) {
      this.target.set( { name: this.getNameInput().value } );
    }
  JS

  def card_configuration
    {
      :items => [{
        :label => 'name',
        :cls => 'name',
        :xtype => :textfield
      },{
        :text => 'Submit',
        :xtype => :button,
        :handler => 'editSubmitHandler'
      }]
    }
  end

#############
# Main
#############

  js_method :getNameInput, <<-JS
    function(){
      return Ext.select( 'div.name input' ).elements[0];
    }
  JS

  js_method :init_card, <<-JS
    function(){
      this.on('activate', function() {
        this.getNameInput().value = this.target.data.name;
      });
    }
  JS

end

