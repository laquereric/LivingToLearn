class Spreadsheet::LocalPayers < Spreadsheet::Spreadsheet

  def initialize(params)
    self.class.filename= "#{self.google_path(params[:section])}" if params[:section]
    super
  end

  def google_filename(section)
    fn= self.class.to_s.split('::')[1]
    "#{fn}T#{section.to_s}.gxls"
  end

  def google_path(section)
    File.join( 'TutoringClub', 'Data','Parents', 'Potential',self.google_filename(section) )
  end

  def self.headers
    [ 
      'ProspectId',
      'Prefix','First Name','Middle Name','LastName','Address Line1','Address Line2',
      'City','State','Zip'
    ]
  end

end

