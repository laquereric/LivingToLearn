class Organization::OrganizationDetail < Detail

  belongs_to :organization, :foreign_key => :entity_id

  def self.cardinality
    :one
  end

  def self.entity_class
    Organization::Organization
  end

  belongs_to :organization_entity, :class_name => 'Entity', :foreign_key => :entity_id
  named_scope :named, lambda { |name|
    { :include => :organization_entity, :conditions => ["entities.name = ?", name] }
  }

  def self.purge
    Organization::SesProvider.delete_all
  end

end
