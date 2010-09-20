class Location < ActiveRecord::Base
  def self.fields_used
    [ :address_line1,:address_line2,:city,:state,:zip ]
  end

  def self.get_location_hash(hash)
    location_hash= {}
    self.fields_used.each{ |field|
      location_hash[field]= hash[field]
    }
    return location_hash
  end

end
