class Touch::Card::Goal::Addsub < Touch::Tab::Goal
  js_base_class "Ext.form"

##########################
#
##########################

  js_method :addsubSubmitHandler, <<-JS
    function(button, event) {
      var store = Ext.StoreMgr.get('Activity_store');
      var newData = {
        name: this.getNameInput().value
      };
      if (this.target) {
        newData.parentId = this.target.data.id;
        newData.level = this.target.data.level + 1;
      } else {
        newData.parentId = "";
        newData.level = 0;
      };

      var added = store.add(newData);
      added[0].phantom = true;
      this.goBack();
    }
  JS

  js_method :getNameInput, <<-JS
    function(){
      return Ext.select( 'div.goal.addsub div.name input' ).elements[0];
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

