class Spreadsheet::LocalPayers < Spreadsheet::Spreadsheet

  def self.get_section_filename(section)
    ins= self.new({:section=>section})
    "#{ins.google_path(section)}"
  end

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
      'Prefix', 'First Name', 'Middle Name', 'LastName',
      'Address Line1',
      'Address Line2',
      'City', 'State', 'Zip'
    ]
  end

  def self.identity_class
    Person::ParentPotentialPayer
  end

  def self.store_hash( filename, hash )
      person_entity, person_details =
         self.identity_class.find_or_add_name_details( Person::Person.get_name_hash( hash ),{
      },{
        :source  => filename,
        :prospect_id  => hash[:prospect_id]
      } )
      location_hash= Location.get_location_hash( hash )
      location= Location.new( location_hash )
      person_entity.locations<< location
      person_entity.save
      location.save
  end

end

