require 'test_helper'

class GovernmentSchoolDistrictTest < ActiveSupport::TestCase

  def setup
  end

  def test_should_be_able_to_add
    sd= Government::SchoolDistrict.add( { :name=>"Washington Township School District"})
    assert_equal sd.errors.count, 0
    assert_equal sd.entity_details.count , 1
  end

  def test_should_not_be_able_to_add_wo_name
    sd= Government::SchoolDistrict.add( {} )
    assert_not_equal sd.errors.count, 0
  end

  def test_should_be_able_to_find_or_add_name_wo_dup
    sc = Government::SchoolDistrict.find_or_add_name_details( "Wedgewood Elementary School", {:government_county_id => 1} )
    assert_equal Government::SchoolDistrict.count, 1
    sc = Government::SchoolDistrict.find_or_add_name_details( "Wedgewood Elementary School", {:government_county_id => 1} )
    assert_equal Government::SchoolDistrict.count, 1
  end

  def test_should_be_able_to_find_or_add_names_with_unique_details
    sc = Government::SchoolDistrict.find_or_add_name_details( "Wedgewood Elementary School", {:government_county_id => 1} )
    assert_equal Government::SchoolDistrict.count, 1
    sc = Government::SchoolDistrict.find_or_add_name_details( "Wedgewood Elementary School", {:government_county_id => 2} )
    assert_equal Government::SchoolDistrict.count, 2
  end

end
