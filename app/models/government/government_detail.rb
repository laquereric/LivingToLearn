class Government::GovernmentDetail < Detail

  def self.cardinality
    :one
  end

  def self.entity_class
    Government::Government
  end

  belongs_to :government_entity, :class_name => 'Entity', :foreign_key => :entity_id

  named_scope :named, lambda { |name|
    { :include => :government_entity, :conditions => ["entities.name = ?", name] }
  }

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

  def self.purge
    Government::Country.delete_all
    Government::State.delete_all
    Government::County.delete_all
    Government::TownshipBoro.delete_all
    Government::Neighborhood.delete_all
    Government::SchoolDistrict.delete_all
    Government::EntityDetail.delete_all
  end

end
