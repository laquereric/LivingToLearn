class Touch::Lib::AccountabilityPage

  def self.config_hash(session_config)
    r= if session_config[:user_signed_in]
      {
        :html => '<h1>Accountability</h1><p>Welcome</p>'
      }
    else
      {
        :html => '<h1>Accountability</h1><p>Make yourself accountable to ... </p><p>First and foremost .. yourself. Also, anyone else you choose.</p>'
      }
    end
    return r
  end

end

