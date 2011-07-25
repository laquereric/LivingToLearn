class Touch::User::UserForm < Netzke::Basepack::FormPanel

=begin
############################
# User Page
############################
      js_method :apply_form_errors, <<-JS
        function(errors) {
          var field;
          Ext.iterate(errors, function(fieldName, message){
            fieldName = fieldName.underscore();
            if ( field = this.getForm().findField(fieldName) || this.getForm().findField(fieldName.replace(/([a-z]+)([0-9])/g, '$1_$2'))) {
              field.markInvalid(message.join('<br/>'));
            }
          }, this);
        }
      JS
=end

end

