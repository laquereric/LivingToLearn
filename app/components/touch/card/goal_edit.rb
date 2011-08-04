class Touch::Card::GoalEdit < Touch::Tab::GoalPage
  js_base_class "Ext.form"
##########################
#
##########################

  js_method :editSubmitHandler, <<-JS
    function(button, event) {
      console.log('editSubmitHandler');
    }
  JS

  def card_configuration
    {
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

#############
# Main
#############

  js_method :init_card, <<-JS
    function(){
    }
  JS

end

