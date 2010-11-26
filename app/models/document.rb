class Document < ActiveRecord::Base
  has_one :document_entity, :foreign_key => :document_id , :dependent => :destroy
  has_one :entity, :through => :document_entity

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

  named_scope :from_source, lambda { |source| 
    {:conditions => ["source = ?", source ] } 
  }
 
end
