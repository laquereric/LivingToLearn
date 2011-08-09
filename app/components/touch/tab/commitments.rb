class Touch::Tab::Commitments

  def self.config_hash(session_config)
    r= if session_config[:user_signed_in]
      {
        :html =>  '<h1>Commitments</h1><p>Welcome</p>',
      }
    else
      {
        :html =>  '<h1>Commitments</h1><p>Make personal commitments to the steps meeting your goals.</p>',
      }
    end
  end

end

