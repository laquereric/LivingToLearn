class Spreadsheet::CurrentClients < Spreadsheet::Spreadsheet

#############
# Reflection of Spreadsheet in Object
#############

  def self.connected_object
    Person::Client
  end

############
#
############

   def self.cache_name
     'current_clients'
   end

####################
#
####################

def self.each_client
    ss= self.new
    client_array= ss.class.record_hash_array
    client_array.each{ |client_h|
      yield( Person::Client.create(client_h) )
      #yield(client)
    }
  end

  def self.client_hash
    r= {}
    self.each_client{ |client|
      r[ client[:client_id].to_i]= client
    }
    return r
  end

  def initialize()
    self.class.record_hash_array= Rails.cache.read(self.class.cache_name)
  end

  def google_path
    File.join( 'TutoringClub', 'Data', 'Clients', self.google_filename )
  end


end

