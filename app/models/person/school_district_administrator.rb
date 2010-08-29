class Person::SchoolDistrictAdministrator < Person::PersonDetail

  set_table_name :person_school_district_administrator
  belongs_to :government_school_district_entity, :class_name => "Government::Government", :foreign_key => :government_school_district_entity_id

end
