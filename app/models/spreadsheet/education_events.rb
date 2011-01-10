class Spreadsheet::EducationEvents < Spreadsheet::Spreadsheet

#############
# Reflection of Spreadsheet in Object
#############

  def self.connected_object
    EducationEvent
  end

  def self.each_object(&block)
    self.connected_object.all.each{ |o|
      yield( o )
    }
  end

############
#
############

  def self.cache_name
    'education_events'
  end

####################
#
####################

  def self.each_client(&block)
    self.each_object{ |o|
      yield(o)
    }
  end

  def self.client_hash
    #r= {}
    #self.each_client{ |client|
    #  r[ client[:client_id].to_i]= client
    #}
    return r
  end

  def initialize()
    self.class.record_hash_array= Rails.cache.read(self.class.cache_name)
  end

  def google_path
    File.join( 'TutoringClub', 'Data', 'Clients', 'ClientEducationEvents.gxls' )
  end

end

