require 'test_helper'

class PersonSchoolDistrictAdministratorTest < ActiveSupport::TestCase

  def setup
  end

  def test_should_be_able_to_add
    s_entity, s_details =
      Person::SchoolDistrictAdministrator.add_entity_detail( { :first_name => "john" , :last_name => "jones" } )
    assert_equal s_entity.errors.count, 0
    assert_equal s_entity.entity_details.count , 1
    assert_equal s_details.length , 1
  end

end
