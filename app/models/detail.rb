class Detail < ActiveRecord::Base
  has_one :entity_detail, :foreign_key => :detail_id , :dependent => :destroy
  has_one :entity, :through => :entity_detail

  belongs_to :entity
  validates_presence_of :entity
  validates_associated :entity

  def self.cardinality
    :many
  end

  def name
    self.entity.name
  end

  def self.entities
    Entity.find_by_type(self.to_s)
  end

  def self.add_entity_detail(attrs)
    self.entity_class.add_entity_detail( self, attrs )
  end

  scope :from_source, lambda { |source|
    {:conditions => ["source = ?", source ] }
  }
 
end
