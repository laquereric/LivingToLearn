class Government::GovernmentDetail < Detail

  belongs_to :government, :class_name => 'Entity', :foreign_key => :entity_id
  named_scope :named, lambda { |name| 
    { :include => :government, :conditions => ["entities.name = ?", name] }
  }

  def self.entities
    Entity.find_by_type(self.to_s)
  end

  def name 
    self.entity.name
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

  def self.add_entity_detail(attrs)
    Government::Government.add_entity_detail( self, attrs )
  end

  def self.find_by_name_and_details( name, details )
    entity_details= self.named(name).find( :all, :conditions => details ).compact
    #TODO error check
    entity= if entity_details.length > 0 then entity_details[0].entity else nil end
    return entity, entity_details #.map{|ed| ed.detail}
  end

  def self.find_or_add_name_details( name, unique_details={}, other_details={} )
    rec= nil
    entity, details =
      self.find_by_name_and_details( name , unique_details )
    if entity.nil?
     entity, details =
       self.add_entity_detail( { :name => name }.merge( unique_details).merge( other_details) )
    end
    return entity, details
  end

end
