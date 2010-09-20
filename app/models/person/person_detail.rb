class Person::PersonDetail < Detail

  belongs_to :person_entity, :class_name => 'Entity', :foreign_key => :entity_id

  def self.entity_class
    Person::Person
  end

  named_scope :last_name, lambda { |last_name|
    { :include => :person_entity, :conditions => ["entities.last_name = ?", last_name] }
  }

  named_scope :first_name, lambda { |first_name|
    { :include => :person_entity, :conditions => ["entities.first_name = ?", first_name] }
  }

  def self.find_by_name_hash( name_hash )
    entity_details= self.last_name( name_hash[:last_name] ).first_name( name_hash[:first_name] )
#.find( :all, :conditions => unique_details ).compact
    #TODO error check
    entity= if entity_details.length > 0 then entity_details[0].entity else nil end
    return entity, entity_details
  end

  def self.find_or_add_name_details( name_hash, unique_details={}, other_details={} )
    rec= nil
    entity, details = self.find_by_name_hash( name_hash )
    if entity.nil?
      entity, details =
        self.add_entity_detail( name_hash.merge( unique_details).merge( other_details) )
    else
      if self.cardinality == :one
      end
    end
    return entity, details
  end


end
