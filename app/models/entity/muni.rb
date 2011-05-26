class Entity::Muni

  def self.path_for(sd)
    fields = []
    fields << "entitytype_#{sd.type_name}"
    fields << "name_#{sd.muni}"
    fields << "muni_#{sd.muni}"
    fields << "county_#{sd.county}"
    fields << "state_#{sd.state}"
    fields << "country_#{sd.country}"
    return fields.join('.')
  end

  def friendly_type_name
    "Municipality"
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

  def self.create_from_potential_kvn_sponsors
    PotentialKvnSponsors.municipalities.each{ |m|
      self.create({
        #:ref_type => 'PotentialKvnSponsors',
        #:ref_field => 'infousa_id',
        #:ref_value => m.infousa_id,
        :country=>'us',
        :state=>'us',
        :county=>'gloucester',
        :muni =>  m.downcase.gsub('-','_').gsub(' ','_'),
        :name => m.downcase.gsub('-','_').gsub(' ','_'),
        :theme => 'CharacterJi'
        #:giveaway
        #:prize
        #:email
      })
    }
  end
end
