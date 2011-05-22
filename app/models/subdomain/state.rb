class Subdomain::State < Subdomain::Base

  def path()
    fields = []
    fields << "name_#{self.state}"
    fields << "state_#{self.state}"
    fields << "country_#{self.country}"
    return fields.join('.')
  end

end
