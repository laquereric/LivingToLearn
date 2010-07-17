require 'test_helper'

class GovernmentStateTest < ActiveSupport::TestCase

  def setup
  end

  def test_should_be_able_to_add
    state_entity , state_details =
      Government::State.add_entity_detail( { :name => "New Jersey" } )
    assert_equal state_entity.errors.count, 0
    assert_equal state_entity.entity_details.count , 1
    assert_equal state_details.length , 1
  end

  def test_should_not_be_able_to_add_wo_name
    state_entity , state_details =
       Government::State.add_entity_detail( {} )
    assert_not_equal state_entity.errors.count, 0
  end

  def test_should_be_able_to_find_or_add_name_wo_dup
    state_entity , state_details =
      Government::State.find_or_add_name_details( "New Jersey", {} )
    assert_equal Government::State.count, 1
    state_entity , state_details =
      Government::State.find_or_add_name_details( "New Jersey", {} )
    assert_equal Government::State.count, 1
  end

end
