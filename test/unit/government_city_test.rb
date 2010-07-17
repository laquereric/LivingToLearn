require 'test_helper'

class GovernmentCityTest < ActiveSupport::TestCase

  def setup
  end

  def test_should_be_able_to_add
    country_entity, country_details =
      Government::City.add_entity_detail( { :name => "Sewell" } )
    assert_equal country_entity.errors.count, 0
    assert_equal country_entity.entity_details.count , 1
    assert_equal country_details.length , 1
  end

  def test_should_not_be_able_to_add_wo_name
    country_entity, country_details =
      Government::City.add_entity_detail( {} )
    assert_not_equal country_entity.errors.count, 0
  end

end
