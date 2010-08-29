class Person::SchoolDistrictAdministrator < Person::PersonDetail

  set_table_name :person_school_district_administrator
  belongs_to :government_school_district_detail, :class_name => "Government::SchoolDistrict", :foreign_key => :government_school_district_detail_id

end
