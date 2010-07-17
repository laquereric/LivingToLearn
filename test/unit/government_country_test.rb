require 'test_helper'

class GovernmentCountryTest < ActiveSupport::TestCase

  def setup
  end

  def test_should_be_able_to_add
    country_entity, country_details =
      Government::Country.add_entity_detail( { :name => "United States" } )
    assert_equal country_entity.errors.count, 0
    assert_equal country_entity.entity_details.count , 1
    assert_equal country_details.length , 1
  end

  def test_should_not_be_able_to_add_wo_name
    country_entity, country_details =
      Government::Country.add_entity_detail( {} )
    assert_not_equal country_entity.errors.count, 0
    assert_equal country_entity.entity_details.count , 0
    assert_equal country_details.length , 0
   end

  def test_should_be_able_to_find_or_add_name_wo_dup
    country_entity, country_details =
      Government::Country.find_or_add_name_details( "United States", {} )
    assert_equal Government::Country.count, 1
    country_entity, country_details =
      Government::Country.find_or_add_name_details( "United States", {} )
    assert_equal Government::Country.count, 1
  end

end
