class Government::GovernmentDetail < Detail
  belongs_to :government, :foreign_key => :entity_id
end
