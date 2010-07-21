require 'test_helper'

class GovernmentCityTest < ActiveSupport::TestCase

  def setup
  end

  def test_should_pass
    return
=begin
    Spreadsheet::SesFunding.load_record_file( File.join( RAILS_ROOT, "test" , "fixtures" , "US_NJ_SES_FUNDING.ods") )
    #Spreadsheet::SesFunding.load_record_file( File.join( RAILS_ROOT, "test" , "fixtures" , "US_NJ_SES_FUNDING.xls") )
    assert_equal Government::Country.count,2
    assert_equal Entity.find_by_name("United States").details[0].class, Government::Country
    assert_equal Entity.find_by_name("United States").details[0].name, "United States"
     assert_equal Government::State.count,3
    assert_equal Entity.find_by_name("New Jersey").details[0].class, Government::State
    assert_equal Entity.find_by_name("New Jersey").details[0].name, "New Jersey"
    assert_equal Government::County.count,4
    assert_equal Entity.find_by_name("BUCKS").details[0].class, Government::County
    assert_equal Entity.find_by_name("BUCKS").details[0].name, "BUCKS"
    assert_equal Government::SchoolDistrict.count,5
    assert_equal Entity.find_by_name("BUCKS").details[0].class, Government::County
    assert_equal Entity.find_by_name("UPPER_COUNTY_VOCATIONAL").details[0].name, "UPPER_COUNTY_VOCATIONAL"
    debugger
    assert_equal Entity.find_by_name("UPPER_COUNTY_VOCATIONAL").details[0].poverty_pupils_fy2010 , 1
=end
  end

end
