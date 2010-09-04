class Government::SchoolDistrict < Government::GovernmentDetail

  set_table_name :government_school_districts
  belongs_to :county_entity, :class_name => "Entity", :foreign_key => :government_county_id
  belongs_to :state_entity, :class_name => "Entity", :foreign_key => :government_state_id
  belongs_to :country_entity, :class_name => "Entity", :foreign_key => :government_country_id

  has_many :person_school_district_administrator_details,
    :class_name => "Person::SchoolDistrictAdministrator",
    :foreign_key => :government_school_district_detail_id

  attr_accessor :spreadsheets

  def self.csv_for_records(records)
    p "Pulling CSV from database"
    csv= Document::Csv.new
    csv.record_hash_array= records.map{ |sd|
      sd.get_csv_hash()
    }
    csv.set_header_symbols_from_hash
    csv.set_header_titles_from_symbols
    csv.get_output
  end

  def get_csv_hash()
    rh = {}
    rh[:country]= self.country_entity.name
    rh[:state]= self.state_entity.name
    rh[:county]= Government::County.full_name_pretty(self.county_entity)
    rh[:school_district]= Government::SchoolDistrict.full_name_pretty(self.entity)
    [
        :district_code,
        :at_risk_pupils_fy2011,
        :poverty_pupils_fy2011,
        :ses_allocation_fy2011,
        :per_pupil_allocation_fy2011,
        :after_school_hours,
        :after_school_weeks,
        :at_home_hours,
        :at_home_weeks
    ].each{|f|
        rh[f]= self.send(f)
    }
    rh
  end

  def self.active_list
    self.all.select{ |sd| sd.status == "active" }
  end

  def self.full_name_pretty(entity)
    "#{self.name_pretty(entity)} School District"
  end

  def self.name_pretty(entity)
    entity.name.split('_').map{ |n| n.capitalize}.join(' ')
  end

  def make_active
    self.status="active"
    r= save!
  end

  def spreadsheet_klass(key)
    klass= Spreadsheet::Spreadsheet.spreadsheet_file_keys[key]
    ss_klass= if klass then
      klass
    else
      Spreadsheet::Spreadsheet
    end
    return ss_klass
  end

  def self.csv_filename(key)
    File.join( RAILS_ROOT,'tmp','merge',"#{key.to_s}.csv" )
  end

  def csv_spreadsheet(key)
    ss_klass= spreadsheet_klass(key)
    ss_filename= spreadsheet_filename(key)
    csv_filename= self.class.csv_filename(key)
    ss_klass.csv_record_file(ss_filename,csv_filename)
  end

  def csv_spreadsheets
    spreadsheets= {}
    Spreadsheet::Spreadsheet.spreadsheet_file_keys.each_key{ |key|
      csv_spreadsheet(key)
    }
  end

  def self.google_foldername
    File.join( "TutoringClub" , "Data" , "Government_SchoolDistricts")
  end

  def google_foldername
    File.join( self.class.google_foldername,"#{district_code}__#{name}")
  end

  def spreadsheet_filename(key)
    File.join( google_foldername, "#{key.to_s.camelcase}.gxls")
  end

  def self.at_cursor
    cursor_file= File.open(self.cursor_filename, 'r')
    text= cursor_file.read
    hash= YAML.load(text)
    self.find_by_district_code( hash[:district_code] )
  end

  def self.cursor_filename
    File.join( RAILS_ROOT, 'cursors','Government_SchoolDistrict' )
  end

  def set_cursor
    text = {:district_code => self.district_code}.to_yaml
    File.open(self.class.cursor_filename, 'w') { |f|
      f.write(text)
    }
  end

  def history_total_funded_pupils_fy2010
    at_risk_pupils_fy2010 + poverty_pupils_fy2010
  end

  def history_total_allocation_fy2010
    arra_allocation_fy2010 + ses_allocation_fy2010
  end

  def history_per_pupil_allocation_fy2010
     format('%.0f',total_allocation_fy2010 / total_funded_pupils_fy2010)
  end

  def history_total_allocation_fy2011
    arra_allocation_fy2011 + ses_allocation_fy2010
  end

  def total_funded_pupils_fy2011
    at_risk_pupils_fy2011 + poverty_pupils_fy2011
  end

  def per_pupil_allocation_fy2011
    format('%.0f',ses_allocation_fy2011.to_f / total_funded_pupils_fy2011.to_f )
  end

  def after_school_hours
    format('%.0f', per_pupil_allocation_fy2011.to_f / 43.67)
  end

  def after_school_weeks
     format('%.0f', after_school_hours.to_f / 2 )
  end

  def at_home_hours
     format('%.0f', per_pupil_allocation_fy2011.to_f / 81.88 )
  end

  def at_home_weeks
     format('%.0f',  at_home_hours.to_f / 2 )
  end

end
