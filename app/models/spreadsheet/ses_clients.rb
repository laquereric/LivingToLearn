class Spreadsheet::SesClients < Spreadsheet::Spreadsheet

  def initialize()
    self.class.filename= self.google_path
    self.class.load_record_hash_array
  end

  def google_path
    File.join( 'TutoringClub', 'Data', 'Parents', self.google_filename )
  end

  def self.headers
    [
    'SchoolYear',
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
    'LastCall',
    'Email'
    ]
  end

end

