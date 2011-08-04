class Touch::Card::GoalAddsub < Touch::Tab::GoalPage
  js_base_class "Ext.form"

##########################
#
##########################
  js_method :addsubSubmitHandler, <<-JS
    function(button, event) {
      console.log('addsubSubmitHandler');
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
        :handler => 'addsubSubmitHandler'
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

