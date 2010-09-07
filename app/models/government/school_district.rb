class Government::SchoolDistrict < Government::GovernmentDetail

  set_table_name :government_school_districts
  belongs_to :county_entity, :class_name => "Entity", :foreign_key => :government_county_id
  belongs_to :state_entity, :class_name => "Entity", :foreign_key => :government_state_id
  belongs_to :country_entity, :class_name => "Entity", :foreign_key => :government_country_id

  has_many :person_school_district_administrator_details,
    :class_name => "Person::SchoolDistrictAdministrator",
    :foreign_key => :government_school_district_detail_id

#  has_many :organization_non_profit_details,
#    :class_name => "Organization::NonProfit",
#    :foreign_key => :government_school_district_detail_id


  def self.full_name_pretty(entity)
    "#{self.name_pretty(entity)} School District"
  end

  def self.name_pretty(entity)
    entity.name.split('_').map{ |n| n.capitalize}.join(' ')
  end

#############

  def google_base_folder
    File.join( "TutoringClub" , "Data" , "Government_SchoolDistricts")
  end

  def google_foldername
    File.join( self.google_base_folder,"#{self.district_code}__#{name}")
  end

#########

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

###########

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
