class Person::ParentPotentialPayer < Person::PersonDetail

  set_table_name :person_parent_potential_payer

  #belongs_to :government_school_detail, :class_name => "Government::School", :foreign_key => :government_school_detail_id

  #belongs_to :government_school_district_detail, :class_name => "Government::SchoolDistrict", :foreign_key => :government_school_district_detail_id

  named_scope :min_prospect_id, lambda { |id|
    { :conditions => [ "prospect_id >= ?", id ] }
  }

  def self.next_set(first,count)
    self.min_prospect_id(first).sort{ |r1,r2| r1.prospect_id <=> r1.prospect_id }[0..count-1]
  end

  def get_flat_hash
    fh= {}
    Person::Person.fields_used.each{ |field|
      fh[field]= self.entity.send(field)
    }
    Location.fields_used.each{ |field|
      fh[field]= self.entity.locations[0].send(field)
    }
    fh[:prospect_id]= self.prospect_id
    return fh
  end

end
