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

end
