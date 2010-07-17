require 'test_helper'

class GovernmentNeighborhoodTest < ActiveSupport::TestCase

  def setup
  end

  def test_should_be_able_to_add
    nh= Government::Neighborhood.add( { :name => "Wedgewood" } )
    assert_equal nh.errors.count, 0
    assert_equal nh.entity_details.count , 1
  end

  def test_should_not_be_able_to_add_wo_name
    nh= Government::Neighborhood.add( {} )
    assert_not_equal nh.errors.count, 0
  end

  def test_should_be_able_to_find_or_add_name_wo_dup
    sc = Government::Neighborhood.find_or_add_name_details( "Wedgewood", {} )
    assert_equal Government::Neighborhood.count, 1
    sc = Government::Neighborhood.find_or_add_name_details( "Wedgewood", {} )
    assert_equal Government::Neighborhood.count, 1
  end

end
