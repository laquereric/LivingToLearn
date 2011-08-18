class Touch::Tab::User

################################
# Public Access
#################################

  def self.user_page_tabs_public(session_config)
    [{
       :title =>'Intro',
       :cls => 'default-tab',
       :scroll => :vertical,
       :html => Content.get_html( self, {
         :access => :public,
         :card => :intro
       })
    },{
      :title =>'Login',
      :items => [
        Touch::User::LoginForm.config_hash()
      ]
    },{
      :title =>'Register',
      :items => [
        Touch::User::RegisterForm.config_hash()
      ]
    },{
      :title =>'Terms of Service',
      :cls => 'default-tab',
      :scroll => :vertical,
      :html => Content.get_html( self, {
         :access => :public,
         :card => :terms_of_service
       })
    }
    ]
  end

  def self.config_hash_public(session_config)
    {
    :docked_items => [{
      :dock => :top,
      :xtype => :panel,
      :html => 'Use Your Account'
    }],
    :xtype => :tabpanel,
    :items =>  user_page_tabs_public( session_config )
    }
  end


################################
# User Access
#################################

  def self.user_page_tabs_private(session_config)
    [{
       :title =>'Intro',
       :cls => 'default-tab',
       :scroll => :vertical,
       :html => Content.get_html( self, {
         :access => :private,
         :card => :intro
       })
    },{
      :title =>'Logout',
      :items => [
        Touch::User::LogoutForm.config_hash()
      ]
    }]
  end

  def self.config_hash_private(session_config)
    {
    :docked_items => [{
      :dock => :top,
      :xtype => :panel,
      :cls => :'top-tab-title',
      :html => '<h1>Our Service is Ready for You</h1>'
    }],
    :xtype => :tabpanel,
    :items =>  user_page_tabs_private( session_config )
    }
  end

################################
#
#################################

  def self.config_hash(session_config)
    r= if session_config[:user_signed_in]
      config_hash_private(session_config)
    else
      config_hash_public(session_config)
    end
  end

end

