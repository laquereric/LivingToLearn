module NetzkeComponentExtend

#############
# Toolbars
#############


def route_toolbars
  format='iphone'

  js_method :to_login, <<-JS
    function(){
      window.location="/login.#{format}";
    }
  JS

  js_method :to_register, <<-JS
    function(){
      window.location="/register.#{format}";
    }
  JS

  js_method :to_logout, <<-JS
    function(){
console.log("to logout");
      window.location="/logout.#{format}";
    }
  JS

  @toolbars_routed= true
end

################
# Initialize
################

  def netzke( view, config = {} )
    configr= Configurator.new(config,view)
    yield(configr) if block_given?
    config= configr.contents
    config[:class_name]= self
    config[:user_signed_in]= view.user_signed_in?
    return view.send(:netzke, :touch, config)
  end

end
