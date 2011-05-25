class Subdomain::NonProfit < Subdomain::Base

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

  def self.create_from_potential_kvn_sponsors
    PotentialKvnSponsors.all_public.each{ |m|
      r = self.create({
        :ref_type => 'PotentialKvnSponsors',
        :ref_field => 'infousa_id',
        :ref_value => m.infousa_id,
        :country=>'us',
        :state=>'us',
        :county=>'gloucester',
        :muni =>  m.city.downcase.gsub('-','_').gsub(' ','_'),
        :name => m.company_name.downcase.gsub('-','_').gsub(' ','_'),
        :theme => 'CharacterJi'
        #:giveaway
        #:prize
        #:email
      })

      p r.path

    }
    return nil
  end

end
