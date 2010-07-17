require 'test_helper'

class GovernmentSchoolTest < ActiveSupport::TestCase

  def setup
  end

  def test_should_be_able_to_add
    sc= Government::School.add( { :name => "Wedgewood Elementary School" } )
    assert_equal sc.errors.count, 0
    assert_equal sc.entity_details.count , 1
  end

  def test_should_not_be_able_to_add_wo_name
    sc= Government::School.add( {} )
    assert_not_equal sc.errors.count, 0
  end

  def test_should_be_able_to_find_or_add_name_wo_dup
    sc = Government::School.find_or_add_name_details(  "Wedgewood Elementary School" , {} )
    assert_equal Government::School.count, 1
    sc = Government::School.find_or_add_name_details(  "Wedgewood Elementary School" , {} )
    assert_equal Government::School.count, 1
  end

end
