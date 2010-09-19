class Person::ParentPotentialPayer < Person::PersonDetail

  set_table_name :person_parent_potential_payer
  belongs_to :government_school_detail, :class_name => "Government::School", :foreign_key => :government_school_detail_id
  belongs_to :government_school_district_detail, :class_name => "Government::SchoolDistrict", :foreign_key => :government_school_district_detail_id

end
