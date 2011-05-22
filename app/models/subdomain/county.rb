class Subdomain::County < Subdomain::Base

  def path()
    fields = []
    fields << "type_#{self.type_name}"
    fields << "name_#{self.county}"
    fields << "county_#{self.county}"
    fields << "state_#{self.state}"
    fields << "country_#{self.country}"
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
