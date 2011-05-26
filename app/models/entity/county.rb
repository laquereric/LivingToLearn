class Entity::County

  def self.path_for(sd)
    fields = []
    fields << "type_#{sd.type_name}"
    fields << "name_#{sd.county}"
    fields << "county_#{sd.county}"
    fields << "state_#{sd.state}"
    fields << "country_#{sd.country}"
    return fields.join('.')
  end

#########
#
#########

  def friendly_entity_name
    "#{self.name.titleize} County"
  end

#########
# Utilties for Site Message Block
#########

  def site_type_title
    "Site for #{self.friendly_type_name}"
  end

  def site_location_lines
    "Located in #{self.state.capitalize}"
  end

end
