require 'test_helper'

class GovernmentSchoolTest < ActiveSupport::TestCase

  def setup
  end

  def test_should_be_able_to_add
    school_entity, school_details =
      Government::School.add_entity_detail( { :name => "Wedgewood Elementary School" } )
    assert_equal school_entity.errors.count, 0
    assert_equal school_entity.entity_details.count , 1
    assert_equal school_details.length , 1
  end

  def test_should_not_be_able_to_add_wo_name
    school_entity, school_details =
      Government::School.add_entity_detail( {} )
    assert_not_equal school_entity.errors.count, 0
  end

  def test_should_be_able_to_find_or_add_name_wo_dup
    school_entity, school_details =
      Government::School.find_or_add_name_details(  "Wedgewood Elementary School" , {} )
    assert_equal Government::School.count, 1
    school_entity, school_details =
      Government::School.find_or_add_name_details(  "Wedgewood Elementary School" , {} )
    assert_equal Government::School.count, 1
  end

end
