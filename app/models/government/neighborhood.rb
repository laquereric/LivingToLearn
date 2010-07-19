class Government::Neighborhood < Government::GovernmentDetail
  set_table_name :government_neighborhoods
  belongs_to :township_boro_entity, :class_name => "Entity", :foreign_key => :government_township_boro_id
  belongs_to :county_entity, :class_name => "Entity", :foreign_key => :government_county_id
  belongs_to :state_entity, :class_name => "Entity", :foreign_key => :government_state_id
  belongs_to :country_entity, :class_name => "Entity", :foreign_key => :government_country_id

  def self.add_to_township_boro( name, township_boro )
  neighborhood= self.new
  self.government_township_boro_id
  belongs_to :county_entity, :class_name => "Entity", :foreign_key => :government_county_id
  belongs_to :state_entity, :class_name => "Entity", :foreign_key => :government_state_id
  belongs_to :country_entity, :class_name => "Entity", :foreign_key => :government_country_id
  end
end
