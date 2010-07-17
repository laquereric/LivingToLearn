require 'test_helper'

class GovernmentTownshipBoroTest < ActiveSupport::TestCase

  def setup
  end

  def test_should_be_able_to_add
    twp= Government::TownshipBoro.add( { :name => "Washington Township" } )
    assert_equal twp.errors.count, 0
    assert_equal twp.entity_details.count , 1
  end

  def test_should_not_be_able_to_add_wo_name
    twp= Government::TownshipBoro.add( {} )
    assert_not_equal twp.errors.count, 0
  end

  def test_should_be_able_to_find_or_add_name_wo_dup
    sc = Government::TownshipBoro.find_or_add_name_details( "Washington Township", {} )
    assert_equal Government::TownshipBoro.count, 1
    sc = Government::TownshipBoro.find_or_add_name_details( "Washington Township", {} )
    assert_equal Government::TownshipBoro.count, 1
  end

end
