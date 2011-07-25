class Touch::User::LogoutForm < Touch::Lib::FormPanel

  js_method :to_logout, <<-JS
    function(){
      window.location="/logout.iphone";
    }
  JS

  def self.config_hash
    {
      :class_name => self.to_s,
      :items => [{:html=>"Please press 'Logout'"}],
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
             :handler => :to_logout,
             :text => 'Logout'
          }]
        }
      ]
    }
  end

end

