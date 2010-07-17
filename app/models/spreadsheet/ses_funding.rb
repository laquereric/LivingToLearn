class Spreadsheet::SesFunding < Spreadsheet::Spreadsheet

  def self.load_records()
    self.filename = File.join( RAILS_ROOT, "data" , "US_NJ_SES_FUNDING.ods")
p "header:"
    self.each_header 
    self.convert_header()
    self.lookup_cache = {
      :countries => {},
      :states => {},
      :counties => {},
      :school_districts => {},
    }

p "records:"
    self.each_record { |row,r|
p row.inspect
p "hash: #{r.inspect}"

      country_entity, country_details = Government::Country.find_or_add_name_details( r['country'],{} )
p "country_entity: #{country_entity.inspect} country_details: #{ country_details.inspect}"

      state_entity, state_details = Government::State.find_or_add_name_details( r['state'], {
             :government_country_id => country_entity.id
           } )
p "state_entity: #{state_entity.inspect} state_details: #{ state_details.inspect}"

      county_entity, county_details = Government::County.find_or_add_name_details( r['county'],{
             :government_country_id => country_entity.id,
             :government_state_id => state_entity.id
           }  )
p "county_entity: #{county_entity.inspect} county_details: #{ county_details.inspect}"

      school_district_entity, school_district_details =
        Government::SchoolDistrict.find_or_add_name_details( r['district'],{
             :government_country_id => country_entity.id,
             :government_state_id => state_entity.id,
             :government_county_id => county_entity.id,

             :government_district_code  => r['government_district_code']
        },{
             :at_risk_pupils_fy2010  => r['at_risk_pupils_fy2010'],
             :poverty_pupils_fy2010  => r['poverty_pupils_fy2010'],
             :arra_allocation_fy2010  => r['arra_allocation_fy2010'],
             :ses_allocation_fy2010  => r['ses_allocation_fy2010']
        } )
p "school_district_entity: #{school_district_entity.inspect} county_details: #{ school_district_details.inspect}"
  }

  end

end
