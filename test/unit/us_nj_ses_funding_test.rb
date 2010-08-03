require 'test_helper'

class GovernmentCityTest < ActiveSupport::TestCase
  attr_accessor :filename

  def setup
  end

  def test_xls_cell_values
   #Spreadsheet::SesFunding.load_record_file( File.join( RAILS_ROOT, "test" , "fixtures" , "US_NJ_SES_FUNDING.xls") )
  end

  def test_ods_cell_values
    self.filename= File.join( RAILS_ROOT, "test" , "fixtures" , "US_NJ_SES_FUNDING.ods")
    confirm_cell_values
  end

  def confirm_cell_values
    spreadsheet= Spreadsheet::SesFunding.load_record_file( filename )

    assert_equal spreadsheet.cell(2,1),"United States"
    assert_equal Government::Country.count,2
    assert_equal Entity.find_by_name("United States").details[0].name, "United States"

    assert_equal spreadsheet.cell(2,2),"New Jersey"
    assert_equal Government::State.count,3
    assert_equal Entity.find_by_name("New Jersey").details[0].class, Government::State
    assert_equal Entity.find_by_name("New Jersey").details[0].name, "New Jersey"

    assert_equal spreadsheet.cell(2,3),"ATLANTIC"
    assert_equal Government::County.count,4
    assert_equal Entity.find_by_name("BUCKS").details[0].class, Government::County
    assert_equal Entity.find_by_name("BUCKS").details[0].name, "BUCKS"
    assert_equal Government::SchoolDistrict.count,5
    assert_equal Entity.find_by_name("BUCKS").details[0].class, Government::County

    assert_equal spreadsheet.cell(6,5),"UPPER_COUNTY_VOCATIONAL"
    assert_equal Entity.find_by_name("UPPER_COUNTY_VOCATIONAL").details[0].name, "UPPER_COUNTY_VOCATIONAL"
    assert_equal spreadsheet.cell(6,7),125.0
    assert_equal Entity.find_by_name("UPPER_COUNTY_VOCATIONAL").details[0].at_risk_pupils_fy2010 , 125.0
  end

end
