class Touch::Card::GoalAddsub < Touch::Tab::GoalPage
  js_base_class "Ext.form"

##########################
#
##########################

  js_method :addsubSubmitHandler, <<-JS
    function(button, event) {
      console.log('addsubSubmitHandler')
      var store = this.target.store;
      var new_rec = {
        name: this.getNameInput().value,
        parentId: this.target.data.id
      };
      store.add(new_rec);
    }
  JS

  js_method :getNameInput, <<-JS
    function(){
      return Ext.select( 'div.name input' ).elements[0];
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

