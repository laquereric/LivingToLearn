class Touch::Lib::GoalsPage

  def self.config_hash(session_config)
    r= if session_config[:user_signed_in]
       {
        :html =>  '<h1>Goals</h1><p>Welcome</p>',
      }
    else
      {
      :html =>  '<h1>Goals</h1><p>Identify what goals you want help achieving.</p>',
      }
    end
  end

end

