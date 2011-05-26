class Entity::Business

  def self.path_for(sd)
    fields = []
    fields << "entitytype_#{sd.type_name}"
    fields << "name_#{sd.name}"
    fields << "muni_#{sd.muni}"
    fields << "county_#{sd.county}"
    fields << "state_#{sd.state}"
    fields << "country_#{sd.country}"
    return fields.join('.')
  end

  def self.create_from_potential_kvn_sponsors
    PotentialKvnSponsors.all_private.each{ |m|
      r = self.create({
        :ref_type => 'PotentialKvnSponsors',
        :ref_field => 'infousa_id',
        :ref_value => m.infousa_id,
        :country=>'us',
        :state=>'us',
        :county=>'gloucester',
        :muni =>  m.city.downcase.gsub('-','_').gsub(' ','_'),
        :name => m.company_name.downcase.gsub('-','_').gsub(' ','_').gsub('.','_'),
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
