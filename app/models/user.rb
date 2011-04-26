class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  #validates_presence_of :name
  #validates_uniqueness_of :name, :email, :case_sensitive => false

  validates_presence_of :email
  validates_uniqueness_of :email, :case_sensitive => false

  has_many :marketing_contexts
  has_many :marketing_context_types, :through => :marketing_contexts, :source => "marketing_context_type"

  def add_marketing_context(id)
    marketing_context_type = MarketingContextType.find(id)
    #marketing_context_type = MarketingContextType.find_by_name(name)
    self.marketing_context_types << marketing_context_type if marketing_context_type
    r = if marketing_context_type then marketing_context_type else nil end
  end
end
