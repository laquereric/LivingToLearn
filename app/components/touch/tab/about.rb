class Touch::Tab::About

############################
# About Page - Public
############################

  def self.about_page_tabs_public(session_config)
    [{
       :title =>'Mission',
       :cls => 'default-tab',
       :scroll => :vertical,
       :html => <<-JS
We help your friends help you improve some part of your life.</br>
</br>
How do you do it?</br>
</br>
First, you identify some goal.</br>
</br>
Next you make a commitment to taking a step needed to move towards that goal.</br>
</br>
Then, you identify the friends (and others) who you want to help you to be accountable (your accountability partners).</br>
</br>
Whether you meet your commitment or not, your accountability partners are kept informed.</br>
</br>
This will work with the help of our service or without it. We just make it a little easier.</br>
</br>
See 'Vision' to learn more.
JS
    },{
      :title =>'Vision',
      :cls => 'default-tab',
      :scroll => :vertical,
      :html => <<-JS
You will begin moving to your goal in a matter of minutes! Please continue ...</br>
</br>
First, what type of goal do you want to pursue? Do you want an 'A' in Chemistry? Do you want to pray for 5 minutes a day?</br>
</br>
To proceed, register yourself (under User), describe your goal (under Goals), and then make some commitment towards achieving that goal (under commitments).</br>
</br>
Now is the most important part ... invite your friends to help you be accountable (under accountability).</br>
</br>
That's it! As we promised, you will be off and running very soon.
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
        :html => 'Improve (part of) your life now!'
      }],
      :xtype => :tabpanel,
      :items =>  about_page_tabs_public(session_config),
      }
  end

######################################
#
######################################

  def self.about_page_tabs_private(session_config)
    [{
       :title =>'Mission',
       :cls => 'default-tab',
       :scroll => :vertical,
       :html => <<-JS
Welcome
JS
    },{
      :title =>'Vision',
      :cls => 'default-tab',
      :scroll => :vertical,
      :html => <<-JS
Welcome
JS
    }
    ]
  end

  def self.config_hash_private(session_config)
      {
      :docked_items => [{
        :dock => :top,
        :xtype => :panel,
        :cls => :'top-tab-title',
        :html => 'Improve (part of) your life now!'
      }],
      :xtype => :tabpanel,
      :items =>  about_page_tabs_private(session_config),
      }
  end

#########################
#
#########################

  def self.config_hash(session_config)
    r= if session_config[:user_signed_in]
      config_hash_private(session_config)
    else
      config_hash_public(session_config)
    end
  end

end

