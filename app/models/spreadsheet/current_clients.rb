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
      'Select','Client Id',
      'ProgramS',
      'Prefix','First Name','Middle Name','Last Name','Suffix',
      'Email',
      'Last Consumed Hour','Last Paid Hour',
      'Give Invoice','Contract Hrs Per Week','Prev Contract End Hour','Contracted Hours','Last Contract Hour',
      'Direct','Prepaid','Active',
      'AddressLine1','AddressLine2','City','State','Zip','Phone1','Phone2',
      'DOB','Grade','School',
      'ParentXxPrefix','ParentXxFirstName','ParentXxMiddleName','ParentXxLastName','ParentXxSuffix',
      'ParentXyPrefix','ParentXyFirstName','ParentXyMiddleName','ParentXyLastName','ParentXySuffix', 'School District'
    ]
  end

end

