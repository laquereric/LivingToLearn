class Government::State < Government::GovernmentDetail
  set_table_name :government_states
  belongs_to :country_entity, :class_name => "Entity", :foreign_key => :government_country_id
end
