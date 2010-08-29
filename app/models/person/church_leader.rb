class Person::ChurchLeader < Person::PersonDetail

  set_table_name :person_church_leaders
  belongs_to :organization_church_detail, :class_name => "Organization::Church", :foreign_key => :organization_church_detail_id

end
