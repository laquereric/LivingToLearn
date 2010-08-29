class Organization::Church < Organization::OrganizationDetail

  set_table_name :organization_churches
  has_many :person_church_leader_details , :class_name => "Person::ChurchLeader", :foreign_key => :organization_church_detail_id


end
