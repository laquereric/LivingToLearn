class Spreadsheet::NonProfitLeaders < Spreadsheet::Spreadsheet
  attr_accessor :school_district

  def initialize(school_district)
    self.school_district= school_district
    self.class.filename= self.google_path
    self.class.load_record_hash_array
  end

  def google_path
    File.join( self.school_district.google_foldername, google_filename )
  end

  def self.headers
    [
    'select','Prefix','FirstName','MiddleName','LastName','Suffix',
    'Title','NonProfitName',
    'AddressLine1',
    'AddressLine2',
    'City','State','Zip',
    'Phone','Extension',
    'Email','Web','Spoke'
    ]
  end

end

