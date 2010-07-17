require 'test_helper'

class GovernmentCountyTest < ActiveSupport::TestCase

  def setup
  end

  def test_should_be_able_to_add
    cnt= Government::County.add( { :name => "Gloucester County" } )
    assert_equal cnt.errors.count, 0
    assert_equal cnt.entity_details.count , 1
  end

  def test_should_not_be_able_to_add_wo_name
    cnt= Government::County.add( {} )
    assert_not_equal cnt.errors.count, 0
  end

  def test_should_be_able_to_find_or_add_name_wo_dup
    sc = Government::County.find_or_add_name_details(  "Gloucester County" , {} )
    assert_equal Government::County.count, 1
    sc = Government::County.find_or_add_name_details(  "Gloucester County" , {} )
    assert_equal Government::County.count, 1
  end

end
