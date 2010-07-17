require 'test_helper'

class GovernmentCountyTest < ActiveSupport::TestCase

  def setup
  end

  def test_should_be_able_to_add
    county_entity, county_details =
      Government::County.add_entity_detail( { :name => "Gloucester County" } )
    assert_equal county_entity.errors.count, 0
    assert_equal county_entity.entity_details.count , 1
    assert_equal county_details.length , 1
  end

  def test_should_not_be_able_to_add_wo_name
    county_entity, county_details =
      Government::County.add_entity_detail( {} )
    assert_not_equal county_entity.errors.count, 0
  end

  def test_should_be_able_to_find_or_add_name_wo_dup
    county_entity, county_details =
      Government::County.find_or_add_name_details(  "Gloucester County" , {} )
    assert_equal Government::County.count, 1
    county_entity, county_details =
      Government::County.find_or_add_name_details(  "Gloucester County" , {} )
    assert_equal Government::County.count, 1
  end

end
