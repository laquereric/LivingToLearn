class Subdomain::Muni < Subdomain::Base

  def path()
    fields = []
    fields << "type_#{self.type_name}"
    fields << "name_#{self.muni}"
    fields << "muni_#{self.muni}"
    fields << "county_#{self.county}"
    fields << "state_#{self.state}"
    fields << "country_#{self.country}"
    return fields.join('.')
  end

  def friendly_type_name
    "Municipal"
  end

#########
# Utilties for Site Message Block
#########

  def site_type_title
    "Site for #{self.friendly_type_name}"
  end

  def site_location_lines
    "Located in #{self.county.titleize} County , #{self.state.capitalize}"
  end

end
