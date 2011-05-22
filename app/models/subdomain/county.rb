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

end
