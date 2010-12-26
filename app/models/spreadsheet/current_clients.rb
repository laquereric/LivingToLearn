class Spreadsheet::CurrentClients < Spreadsheet::Spreadsheet
  def self.headers

    [
      'Client Id',
      'Select',
      'To Do',
      'Program S',
      'Prefix','First Name','Middle Name','Last Name','Suffix',
      'Email',
      'Last Attended Date','Last Consumed Hour','Last Paid Hour',
      'Give Invoice','Contract Hrs Per Week','Prev Contract End Hour',
      'Contracted Hours','Last Contract Hour', 'Closed End',
      'Direct','Prepaid','Active',
      'AddressLine1','AddressLine2','City','State','Zip','Phone1','Phone2','Phone3',
      'DOB','Grade',
      'ParentXxPrefix','ParentXxFirstName','ParentXxMiddleName','ParentXxLastName','ParentXxSuffix',
      'ParentXyPrefix','ParentXyFirstName','ParentXyMiddleName','ParentXyLastName','ParentXySuffix',
      'School District', 'School',
      'Origin', 'Representatives','Result','Status','Location',
      'First Contract',
      'FC Hrs 9',
      'FC Hrs 10',
      'FC Hrs 11',
      'FC Hrs 12',
      'FC Hrs 1',
      'FC Hrs 2',
      'FC Hrs 3',
      'FC Hrs 4',
      'FC Hrs 5',
      'FC Hrs 6',
      'FC Hrs 7',
      'FC Hrs 8',
      'Second Contract',
      'SC Hrs 9',
      'SC Hrs 10',
      'SC Hrs 11',
      'SC Hrs 12',
      'SC Hrs 1',
      'SC Hrs 2',
      'SC Hrs 3',
      'SC Hrs 4',
      'SC Hrs 5',
      'SC Hrs 6',
      'SC Hrs 7',
      'SC Hrs 8'
      ]
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
    client_array.each{ |client|
      yield(client)
    }
  end
#
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

