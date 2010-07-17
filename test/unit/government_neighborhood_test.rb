require 'test_helper'

class GovernmentNeighborhoodTest < ActiveSupport::TestCase

  def setup
  end

  def test_should_be_able_to_add
    neighborhood_entity, neighborhood_details =
      Government::Neighborhood.add_entity_detail( { :name => "Wedgewood" } )
    assert_equal neighborhood_entity.errors.count, 0
    assert_equal neighborhood_entity.entity_details.count , 1
    assert_equal neighborhood_details.length , 1
  end

  def test_should_not_be_able_to_add_wo_name
    neighborhood_entity, neighborhood_details =
      Government::Neighborhood.add_entity_detail( {} )
    assert_not_equal neighborhood_entity.errors.count, 0
  end

  def test_should_be_able_to_find_or_add_name_wo_dup
    neighborhood_entity, neighborhood_details =
      Government::Neighborhood.find_or_add_name_details( "Wedgewood", {} )
    assert_equal Government::Neighborhood.count, 1
    neighborhood_entity, neighborhood_details =
      Government::Neighborhood.find_or_add_name_details( "Wedgewood", {} )
    assert_equal Government::Neighborhood.count, 1
  end

end
