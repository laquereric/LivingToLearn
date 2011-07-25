class Touch::User::LoginForm < Touch::Lib::FormPanel

  js_method :to_login, <<-JS
    function(){
      window.location="/login.iphone";
    }
  JS

  def self.config_hash
    {
      :class_name => self.to_s,
      :items => [{:html=>"Please press 'Login'"}],
=begin
      :items => [{
          :label => 'email',
          :xtype => :emailfield
      },{
          :label => 'password',
          :xtype => :textfield
      }],
=end
      :dockedItems => [
        {
          :xtype => :toolbar,
          :dock => :bottom,
          :items => [{
             :handler => :to_login,
             :text => 'Login'
          }]
        }
      ]
    }
  end

end

