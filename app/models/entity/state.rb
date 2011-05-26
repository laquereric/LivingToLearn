class Entity::State

  def self.path_for(sd)
    fields = []
    fields << "name_#{sd.state}"
    fields << "state_#{sd.state}"
    fields << "country_#{sd.country}"
    return fields.join('.')
  end

#########
#
#########

  def friendly_entity_name
    "#{self.name.titleize} State"
  end

#########
# Utilties for Site Message Block
#########

  def site_type_title
    "Site for #{self.friendly_entity_name}"
  end

  def site_location_lines
    ""
  end

  def site_contact_lines
    "Contact email: #{self.email}"
  end


end
