class Touch::User::RegisterForm < Touch::Lib::FormPanel

  js_method :to_register, <<-JS
    function(){
      window.location="/register.iphone";
    }
  JS

  def self.config_hash
    {
      :class_name => self.to_s,
      :items => [{:html=>"Please press 'Register'"}],
=begin
      :items => [{
          :label => 'email',
          :xtype => :emailfield
      },{
          :label => 'password',
          :xtype => :passwordfield
      },{
          :label => 'password confirmation',
          :xtype => :passwordfield
      }],
=end
      :dockedItems => [
        {
          :xtype => :toolbar,
          :dock => :bottom,
          :items => [{
             :handler => :to_register,
             :text => 'Register'
          }]
        }
      ]
    }
  end
end

