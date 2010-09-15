class Spreadsheet::PayerClients < Spreadsheet::Spreadsheet

  def google_path
    File.join( 'TutoringClub', 'Data', 'Parents' )
  end

  def self.headers
    [
    'StudentFirstName',
    'StudentLastName',
    'FirstName',
    'LastName',
    'AddressLine1',
    'AddressLine2',
    'City',
    'State',
    'Zip',
    'StudentDob',
    'School',
    'SchoolTeacher',
    'Tutor',
    'Phone1',
    'Phone2',
    'Email',
    'LastCall'
    ]
  end

  def self.clean_row_hash(row_hash)
    row_hash[:zip]= "%.5i" % row_hash[:zip]
    row_hash
  end

end

