class Spreadsheet::CurrentClients < Spreadsheet::Spreadsheet

############
#
############

   def self.cache_name
     'current_clients'
   end

   def self.cache_dump
      Rails.cache.read(self.cache_name)
   end

   def self.cache_load
     ss= self.new
     Rails.cache.fetch(ss.class.cache_name) {
       ss.class.filename= ss.google_path
       ss.class.load_record_hash_array
     }
   end

####################
#
#####################
  def self.each_client
    ss= self.new
    client_array= ss.class.record_hash_array
    client_array.each{ |client|
      yield(client)
    }
  end

  def initialize()
    self.class.record_hash_array= Rails.cache.read(self.class.cache_name)
  end

  def google_path
    File.join( 'TutoringClub', 'Data', 'Clients', self.google_filename )
  end


  def self.headers

    [
      'Client Id',
      'Select',
      'To Do',
      'Program S',
      'Prefix','First Name','Middle Name','Last Name','Suffix',
      'Email',
      'Last Consumed Hour','Last Paid Hour',
      'Give Invoice','Contract Hrs Per Week','Prev Contract End Hour','Contracted Hours','Last Contract Hour', 'Closed End',
      'Direct','Prepaid','Active',
      'AddressLine1','AddressLine2','City','State','Zip','Phone1','Phone2','Phone3',
      'DOB','Grade',
      'ParentXxPrefix','ParentXxFirstName','ParentXxMiddleName','ParentXxLastName','ParentXxSuffix',
      'ParentXyPrefix','ParentXyFirstName','ParentXyMiddleName','ParentXyLastName','ParentXySuffix',
      'School District', 'School',
      'Origin', 'Representatives','Result','Status','Location'
    ]
  end

end

