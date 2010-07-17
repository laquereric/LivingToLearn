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
      country_rec = nil
      if ( country_rec = self.lookup_cache[:countries][ r['country'] ] ).nil?
         country_rec = self.lookup_cache[:countries][ r['country'] ] =
           Government::Country.find_or_add_name_details( r['country'],{} )
      end
p "country_rec: #{country_rec.inspect}"
 
      state_rec = nil
      if ( state_rec = self.lookup_cache[:states][ r['state'] ] ).nil?
         state_rec = self.lookup_cache[:states][ r['state'] ] =
           Government::State.find_or_add_name_details( r['state'], {
             :government_country_id => country_rec.id
           } )
      end
p "state_rec: #{state_rec.inspect}"
 
      county_rec = nil
      if ( county_rec = self.lookup_cache[:counties][ r['county'] ] ).nil?
        county_rec = self.lookup_cache[:counties][ r['county'] ] =
           Government::County.find_or_add_name_details( r['county'],{
             :government_country_id => country_rec.id,
             :government_state_id => state_rec.id
           }  )
      end
p "county_rec: #{county_rec.inspect}"
      school_district_rec = nil
      if ( school_district_rec  = self.lookup_cache[:school_districts][ r['district'] ] ).nil?
         school_district_rec = self.lookup_cache[:school_districts][ r['district'] ] =
           Government::SchoolDistrict.find_or_add_name_details( r['district'],{
             :government_country_id => country_rec.id,
             :government_state_id => state_rec.id,
             :government_county_id => county_rec.id,

             :government_district_code  => r['government_district_code']
           },{
             :at_risk_pupils_fy2010  => r['at_risk_pupils_fy2010'],
             :poverty_pupils_fy2010  => r['poverty_pupils_fy2010'],
             :arra_allocation_fy2010  => r['arra_allocation_fy2010'],
             :ses_allocation_fy2010  => r['ses_allocation_fy2010']
           } )
      end
school_district_detail= school_district_rec.entity_details[0].detail
p "school_district: #{school_district_detail.inspect}"
p "school_district_name: #{school_district_detail.government.name}"


p "country: #{school_district_detail.country.inspect}"
p "country_name: #{school_district_detail.country.entity_details[0].detail.government.name}"
p "state_name: #{school_district_detail.state.entity_details[0].detail.government.name}"
p "county_name: #{school_district_detail.county.entity_details[0].detail.government.name}"
   }

  end

end
