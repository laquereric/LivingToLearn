class Subdomain::Business < Subdomain::Base

  def path()
    fields = []
    fields << "type_#{self.type_name}"
    fields << "name_#{self.name}"
    fields << "muni_#{self.muni}"
    fields << "county_#{self.county}"
    fields << "state_#{self.state}"
    fields << "country_#{self.country}"
    return fields.join('.')
  end

end
