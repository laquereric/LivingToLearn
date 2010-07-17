require 'test_helper'

class GovernmentTownshipBoroTest < ActiveSupport::TestCase

  def setup
  end

  def test_should_be_able_to_add
    township_boro_entity, township_boro_details =
      Government::TownshipBoro.add_entity_detail( { :name => "Washington Township" } )
    assert_equal township_boro_entity.errors.count, 0
    assert_equal township_boro_entity.entity_details.count , 1
    assert_equal township_boro_details.length , 1
  end

  def test_should_not_be_able_to_add_wo_name
    township_boro_entity, township_boro_details =
      Government::TownshipBoro.add_entity_detail( {} )
    assert_not_equal township_boro_entity.errors.count, 0
  end

  def test_should_be_able_to_find_or_add_name_wo_dup
    township_boro_entity, township_boro_details =
      Government::TownshipBoro.find_or_add_name_details( "Washington Township", {} )
    assert_equal Government::TownshipBoro.count, 1
    township_boro_entity, township_boro_details =
      Government::TownshipBoro.find_or_add_name_details( "Washington Township", {} )
    assert_equal Government::TownshipBoro.count, 1
  end

end
