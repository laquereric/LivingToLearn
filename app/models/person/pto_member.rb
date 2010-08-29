class Person::PtoMember < Person::PersonDetail

  set_table_name :person_pto_member
  belongs_to :government_school_detail, :class_name => "Government::School", :foreign_key => :government_school_detail_id

end
