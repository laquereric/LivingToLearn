class Touch::Card::GoalDelete < Touch::Tab::GoalPage
  js_base_class "Ext.form"

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


  def card_configuration
    {
      :items => [{
        :label => 'name',
        :xtype => :textfield
      },{
        :text => 'Submit',
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

