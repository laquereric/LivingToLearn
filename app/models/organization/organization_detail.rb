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
  def self.find_by_name_and_details( name, unique_details )
    entity_details= self.named(name).find( :all, :conditions => unique_details ).compact
    #TODO error check
    entity= if entity_details.length > 0 then entity_details[0].entity else nil end
    return entity, entity_details
  end

  def self.find_or_add_name_details( name, unique_details={}, other_details={} )
    rec= nil
    entity, details = self.find_by_name_and_details( name , unique_details )
    if entity.nil?
      entity, details =
        self.add_entity_detail( { :name => name }.merge( unique_details).merge( other_details) )
    else
      if self.cardinality == :one
      end
    end
    return entity, details
  end

end
