class Spreadsheet::SesFunding < Spreadsheet::Spreadsheet

  def self.headers
    [
    'Country','State','County','DistrictCode','District',
    'PovertyPupilsFy2010','AtRiskPupilsFy2010','TotalFundedPupilsFy2010',
    'SesAllocationFy2010','ArraAllocationFy2010','TotalAllocationFy2010','PerPupilAllocationFy2010',

    'PovertyPupilsFy2011',
    'AtRiskPupilsFy2011','TotalFundedPupilsFy2011',
    'SesAllocationFy2011',
    'PerPupilAllocationFy2011',
    'Exceptions',
    'AfterSchool Hours','AtHome Hours',
    'AfterSchoolAttendanceBonus','AtHomeAttendanceBonus',
    'AfterSchoolCommission','AtHomeCommission',
    'AfterSchoolWeeks','AtHomeWeeks',
    'TotalAvail',
    'Sponsor'
    ]
  end

 def self.remove_dolar_sign(raw)
   return raw.to_i if raw.is_a? Float
   m= /\$(.*)/.match(raw)
   r= if m then m[1].to_i else 0 end
 end

 def self.load_records()
    self.each_header
    self.convert_header()
    self.lookup_cache = {
      :countries => {},
      :states => {},
      :counties => {},
      :school_districts => {},
    }

    self.each_record { |row,r|
      country_entity, country_details = Government::Country.find_or_add_name_details( r['country'],{} )

      state_entity, state_details = Government::State.find_or_add_name_details( r['state'], {
             :government_country_id => country_entity.id
           } )

      county_entity, county_details = Government::County.find_or_add_name_details( r['county'],{
             :government_country_id => country_entity.id,
             :government_state_id => state_entity.id
           }  )

      school_district_entity, school_district_details =
        Government::SchoolDistrict.find_or_add_name_details( r['district'],{
             :government_country_id => country_entity.id,
             :government_state_id => state_entity.id,
             :government_county_id => county_entity.id,

             :government_district_code  => r['district_code'].to_i
        },{
             :at_risk_pupils_fy2010  => r['at_risk_pupils_fy2010'].to_i,
             :poverty_pupils_fy2010  => r['poverty_pupils_fy2010'].to_i,
             :arra_allocation_fy2010 => self.remove_dolar_sign(r['arra_allocation_fy2010']),
             :ses_allocation_fy2010  => self.remove_dolar_sign(r['ses_allocation_fy2010']),

             :at_risk_pupils_fy2011  => r['at_risk_pupils_fy2011'].to_i,
             :poverty_pupils_fy2011  => r['poverty_pupils_fy2011'].to_i,
             :ses_allocation_fy2011  => self.remove_dolar_sign(r['ses_allocation_fy2011'])
        } )
    }

  end

  def self.load_record_file(filename)
    self.spreadsheet = nil
    self.filename = filename
    self.load_records()
    self.spreadsheet
  end

  def self.load_data_records()
    self.spreadsheet = nil
    self.load_recordfile( File.join( RAILS_ROOT, "data" , "US_NJ_SES_FUNDING.ods") )
  end

  def self.initialize
    truncate_db_table(:government_country)
    truncate_db_table(:government_state)
    truncate_db_table(:government_county)
    truncate_db_table(:government_school_district)
  end

end
