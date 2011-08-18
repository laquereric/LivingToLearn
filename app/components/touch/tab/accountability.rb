class Touch::Tab::Accountability

  def self.config_hash(session_config)
    r= if session_config[:user_signed_in]
      {
      :html => Content.get_html( self, {
         :access => :private,
         :tab => :accountability
      })
      }
    else
      {
      :html => Content.get_html( self, {
         :access => :public,
         :tab => :accountability
      })
      }
    end
    return r
  end

end

