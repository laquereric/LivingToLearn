class Government::School < Government::GovernmentDetail

  set_table_name :government_schools
  has_many :person_pto_member_details, :class_name => "Person::PtoMember", :foreign_key => :government_school_detail_id

end
