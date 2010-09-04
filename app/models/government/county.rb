class Government::County < Government::GovernmentDetail
  set_table_name :government_counties
  belongs_to :state_entity, :class_name => "Entity", :foreign_key => :government_state_id
  belongs_to :country_entity, :class_name => "Entity", :foreign_key => :government_country_id

  def self.full_name_pretty(entity)
    "#{self.name_pretty(entity)} County"
  end

  def self.name_pretty(entity)
    entity.name.split('_').map{ |n| n.capitalize}.join(' ')
  end

end
