class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :current_marketing_context

  #validates_presence_of :name
  #validates_uniqueness_of :name, :email, :case_sensitive => false

  validates_presence_of :email
  validates_uniqueness_of :email, :case_sensitive => false

  has_many :marketing_contexts, :dependent => :destroy
  has_many :marketing_context_types, :through => :marketing_contexts, :source => "marketing_context_type", :dependent => :destroy

  #has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }

  def add_marketing_context(id)
    marketing_context_type = MarketingContextType.find(id)
    self.marketing_context_types << marketing_context_type if marketing_context_type
    r = if marketing_context_type then marketing_context_type else nil end
  end

  def marketing_contexts_of_type(id)
    self.marketing_contexts.select{ |marketing_context| marketing_context.marketing_context_type.id == id }
  end

  def delete_marketing_contexts_of_type(id)
    marketing_contexts_of_type(id.to_i).each{ |marketing_context|
      self.marketing_contexts.delete(marketing_context)
    }
    self.current_marketing_context = ''
    current_marketing_context_type
    return self.current_marketing_context
  end

  def select_marketing_context_id(id)
    self.current_marketing_context = MarketingContextType.find(id).name
    self.save
  end

  def current_marketing_context_type()
    return nil if self.marketing_context_types.length == 0
    if self.current_marketing_context.length == 0
      id = self.marketing_context_types[0].id
      select_marketing_context_id( id )
    end
    self.marketing_context_types.select{ |marketing_context_type| marketing_context_type.name == self.current_marketing_context }[0]
  end

  def current_marketing_context_type_id()
    type = self.current_marketing_context_type
    r = if type then type.id else nil end
  end

  def contexts
    Context.for_user_email(self.email)
  end

  def registration_context
    Context.user_registrations(self.email)[0]
  end

#######################
#
#######################

  def locked_in_subdomain?
    #current_user.get_locked_subdomain
    false
  end

  def locked_subdomain
    #locked_subdomain_path
    Subdomain::Base.first
  end
end
