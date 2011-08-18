class Touch::Tab::Accountability

  def self.config_hash(session_config)
    r= if session_config[:user_signed_in]
      {
      :html => <<-HTML
<br/><h2>Accountability</h2><br/><br/>Tou will be offered the opportunity to link you commitments to your accountability partners here.<br/><br/>
HTML
      }
    else
      {
        :html =>  <<-HTML
<br/><h2>Accountability</h2><br/><br/>Who is going to hold you accountable for how you spend your time?<br/><br/>Once you are logged in, this tab will allow you to enter your Accountability partners for your activities.<br/><br/>Please press 'User' then either 'Login' to your account or 'Register' to create an new account.
HTML
      }
    end
    return r
  end

end

