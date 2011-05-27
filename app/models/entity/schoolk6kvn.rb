class Entity::Schoolk6kvn

  def self.path_for(sd)
    fields = []
    fields << "entitytype_#{sd.type_name}"
    fields << "name_#{sd.name}"
    fields << "muni_#{sd.muni}"
    fields << "county_#{sd.county}"
    fields << "state_#{sd.state}"
    fields << "country_#{sd.country}"
    return fields.join('.').gsub('_','-')
   end

#########
#
#########

  def self.create_from_government_school_district_kvn
    Government::SchoolK6.all.each{ |m|
      city = m.school_city
      city ||= "city"
      r = Subdomain.create({
        :entitytype => self.to_s,
        :ref_type => 'Government::SchoolK6',
        :ref_field => "district_school_code",
        :ref_value => m.district_school_code,
        :country =>'us',
        :state => 'nj',
        :county => 'gloucester',
        :muni =>  city.downcase.gsub('-','_').gsub(' ','_'),
        :name => m.name.downcase.gsub('-','_').gsub(' ','_').gsub('.','_'),
        :theme => 'CharacterJi'
        #:giveaway
        #:prize
        #:email
      })
      p r.path
    }
    return nil
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
