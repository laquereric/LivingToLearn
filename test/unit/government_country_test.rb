require 'test_helper'

class GovernmentCountryTest < ActiveSupport::TestCase

  def setup
  end

  def test_should_be_able_to_add
    cnt= Government::Country.add( { :name => "United States" } )
    assert_equal cnt.errors.count, 0
    assert_equal cnt.entity_details.count , 1
  end

  def test_should_not_be_able_to_add_wo_name
    cnt= Government::Country.add( {} )
    assert_not_equal cnt.errors.count, 0
  end

  def test_should_be_able_to_find_or_add_name_wo_dup
    sc = Government::Country.find_or_add_name_details( "United States", {} )
    assert_equal Government::Country.count, 1
    sc = Government::Country.find_or_add_name_details( "United States", {} )
    assert_equal Government::Country.count, 1
  end

end
