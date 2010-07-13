class OrganizationDetail < Detail
  belongs_to :organization, :foreign_key => :entity_id
end
