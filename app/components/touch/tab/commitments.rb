class Touch::Tab::Commitments

  def self.config_hash(session_config)
    r= if session_config[:user_signed_in]
      {
        :html =>  '<br/><h2>Commitments</h2><br/><br/>You will be offered the opportunity to enter commitments here.',
      }
    else
      {
      :html => <<-HTML
<br/><h2>Commitments</h2><br/><br/>How much time do you want to dedicate to each of your activities?<br/><br/>Once you are logged in, this tab will allow you make commitments for each of your activities.<br/><br/>Please press 'User' then either 'Login' to your account or 'Register' to create an new account.
HTML
      }
    end
  end

end

