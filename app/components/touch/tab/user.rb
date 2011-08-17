class Touch::Tab::User

################################
# Public Access
#################################

  def self.user_page_tabs_public(session_config)
    [{
       :title =>'Intro',
       :cls => 'default-tab',
       :scroll => :vertical,
       :html => <<-HTML
Having a LivingToLearn account puts you in touch with a few simple tools that can help you move towards your goals (see About for more).</br>
</br>
Already registered? Please press 'Login'.</br>
</br>
In order to begin using out service, you must register with us you must provide us with a password. Why must you register? ... We're glad you asked!</br>
</br>
LivingToLearn provides its users with the tools needed to open up parts of their lives to selected groups of associates. In what ways you are accountable nd to whom is your business. Our account and security system help keep the right information visible and you and your associates while hiding the rest.</br>
</br>
See 'Terms of Service' to learn more.
HTML
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
      :html => <<-JS
JS
    }
    ]
  end

  def self.config_hash_public(session_config)
    {
    :docked_items => [{
      :dock => :top,
      :xtype => :panel,
      :cls => :'top-tab-title',
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
       :html => <<-HTML
If you do not own the email address #{session_config[:current_user].email}, please logout.</br>
HTML
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
      :html => 'Our Service is Ready for You'
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

