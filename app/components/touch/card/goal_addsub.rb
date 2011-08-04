class Touch::Card::GoalAddsub < Touch::Tab::GoalPage
  js_base_class "Ext.form"

##########################
#
##########################

  js_method :addsubSubmitHandler, <<-JS
    function(button, event) {
      console.log('addsubSubmitHandler');
      var store = Ext.StoreMgr.get('Activity_store');
      var newRec = {
        name: this.getNameInput().value
      };
      if (this.target) {
        newRec.parentId = this.target.data.id+''  ;
      } else {
        newRec.parentId = "";
      };
      store.add(newRec);
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

