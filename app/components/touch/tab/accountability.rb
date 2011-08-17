class Touch::Tab::Accountability

  def self.config_hash(session_config)
    r= if session_config[:user_signed_in]
      {
        :html => '<h1>Accountability</h1><p>Welcome</p>'
      }
    else
      {
        :html =>  <<-HTML
<br/><h1><b>Accountability</b></h1><br/><br/>Who is going to hold you accountable for how you spend your time?<br/><br/>Once you are logged in, this tab will allow you to enter your Accountability partners for your activities.<br/><br/>Please press 'User' then either 'Login' to your account or 'Register' to create an new account.
HTML
      }
    end
    return r
  end

end

