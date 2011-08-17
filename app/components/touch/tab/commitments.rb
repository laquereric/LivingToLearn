class Touch::Tab::Commitments

  def self.config_hash(session_config)
    r= if session_config[:user_signed_in]
      {
        :html =>  '<h1>Commitments</h1><p>Welcome</p>',
      }
    else
      {
      :html => <<-HTML
<br/><h1><b>Commitments</b></h1><br/><br/>How much time do you want to dedicate to each of your activities?<br/><br/>Once you are logged in, this tab will allow you make commitments for each of your activities.<br/><br/>Please press 'User' then either 'Login' to your account or 'Register' to create an new account.
HTML
      }
    end
  end

end

