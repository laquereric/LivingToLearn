Touch::User::RegisterForm
Touch::User::LoginForm

class Touch::Lib::Main < Netzke::Base

  js_base_class "Ext.TabPanel"
  extend NetzkeComponentExtend
  include NetzkeComponentInclude

############################
# About Page
############################

  def about_page_tabs(session_config)
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

  def about_page(session_config)
    {
    :docked_items => [{
      :dock => :top,
      :xtype => :panel,
      :cls => :'top-tab-title',
      :html => 'Improve (part of) your life now!'
    }],
    :xtype => :tabpanel,
    :items =>  about_page_tabs(session_config),
    }
  end

############################
# User Page
############################
=begin
      js_method :apply_form_errors, <<-JS
        function(errors) {
          var field;
          Ext.iterate(errors, function(fieldName, message){
            fieldName = fieldName.underscore();
            if ( field = this.getForm().findField(fieldName) || this.getForm().findField(fieldName.replace(/([a-z]+)([0-9])/g, '$1_$2'))) {
              field.markInvalid(message.join('<br/>'));
            }
          }, this);
        }
      JS
      component :login_form do
        {
          :lazy_loading => true,
          #:class_name => "Netzke::Basepack::GridPanel::RecordFormWindow",
          #:title => "Login",
          :title => "Add #{data_class.model_name.human}",
          :button_align => "right",
          :items => [{
            :class_name => "Netzke::Basepack::FormPanel",
            :model => User,
            :items => default_fields_for_forms,
            :persistent_config => config[:persistent_config],
            :strong_default_attrs => config[:strong_default_attrs],
            :border => true,
            :bbar => false,
            :header => false,
            :mode => config[:mode],
            :record => data_class.new(columns_default_values)
          }.deep_merge(config[:add_form_config] || {})]
        }.deep_merge(config[:add_form_window_config] || {})
      end
=end



  def user_page_tabs(session_config)
    [{
       :title =>'Intro',
       :cls => 'default-tab',
       :scroll => :vertical,
       :html => <<-JS
Having a LivingToLearn account puts you in touch with a few simple tools that can help you move towards your goals (see About for more).</br>
</br>
Already registered? Please see 'Login'.</br>
</br>
In order to begin using out service, you must register with us you must provide us with a password. Why must you register? ... We're glad you asked!</br>
</br>
LivingToLearn provides its users with the tools needed to open up parts of their lives to selected groups of associates. In what ways you are accountable nd to whom is your business. Our account and security system help keep the right information visible and you and your associates while hiding the rest.</br>
</br>
See 'Terms of Service' to learn more.
JS
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

  def user_page(session_config)
    {
    :docked_items => [{
      :dock => :top,
      :xtype => :panel,
      :cls => :'top-tab-title',
      :html => 'Begin Using our Service'
    }],
    :xtype => :tabpanel,
    :items =>  user_page_tabs(session_config)
    }
  end

############################
# Goals Page
############################

  def goals_page(session_config)
    {
      :html =>  '<h1>Goals</h1><p>Identify what goals you want help achieving.</p>',
    }
  end

############################
# Commitments Page
############################

  def commitments_page(session_config)
    {
      :html =>  '<h1>Commitments</h1><p>Make personal commitments to the steps meeting your goals.</p>',
    }
  end

############################
# Accountability Page
############################

  def accountability_page(session_config)
    {
      :html => '<h1>Accountability</h1><p>Make yourself accountable to your peers</p>',
    }
  end

  def configuration
    self.class.route_toolbars if @toolbars_routed.nil?
    super.merge(self.screen_config).merge({
      :items => self.tab_items(session_config),
      :ui => 'dark',
      :style => Screen.default.component_style,
      :tabBar => {
        :dock =>  'bottom',
        :layout => {
          :pack =>  'center'
        }
      },
      :cardSwitchAnimation => {
        :type => 'slide',
        :cover => true
      },
      #:defaults => {
      #  #:scroll => 'both'
      #},

     :docked_items => [
        {
          :dock => :top,
          :xtype => :toolbar,
          :title => session_config[:title].to_s
        }
     ],
     :items =>  [{
        :title =>  'About',
        :iconCls => 'info',
        :cls =>  'transparent-class about',
    }.merge(self.about_page(session_config)),{
       :title =>  'User',
       :cls =>  'transparent-class user',
       :iconCls =>  'user',
       :badgeText =>  'Login?'
     }.merge(self.user_page(session_config)),{
       :title =>  'Goals',
       :cls =>  'transparent-class goals',
       :iconCls =>  'download'
     }.merge(self.goals_page(session_config)),{
       :title =>  'Commitments',
       :cls =>  'transparent-class commitments',
       :iconCls =>  'download'
     }.merge(self.commitments_page(session_config)),{
       :title => 'Accountability',
       :cls => 'transparent-class accountability',
       :iconCls =>  'settings'
     }.merge(self.accountability_page(session_config))
     ]
    })
  end

end

