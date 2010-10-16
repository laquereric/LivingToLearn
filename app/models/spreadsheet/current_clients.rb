class Spreadsheet::CurrentClients < Spreadsheet::Spreadsheet

 def initialize()
    self.class.filename= self.google_path
    self.class.load_record_hash_array
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

