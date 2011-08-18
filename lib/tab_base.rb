class TabBase

  def self.config_hash(session_config)
    r= if session_config[:user_signed_in]
      {
      :html => Content.get_html( self, {
         :access => :private
      })
      }
    else
      {
      :html => Content.get_html( self, {
         :access => :public
      })
      }
    end
    return r
  end

end

