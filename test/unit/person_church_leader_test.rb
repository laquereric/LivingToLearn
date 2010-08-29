require 'test_helper'

class PersonChurchLeaderTest < ActiveSupport::TestCase

  def setup
  end

  def test_should_be_able_to_add
    cl_entity, cl_details =
      Person::ChurchLeader.add_entity_detail( { :first_name => "john" , :last_name => "jones" } )
    assert_equal cl_entity.errors.count, 0
    assert_equal cl_entity.entity_details.count , 1
    assert_equal cl_details.length , 1
  end

  def test_should_be_able_to_associate
    c_entity, c_details =
      Organization::Church.add_entity_detail( { :name => "Big Church" } )
    c_detail= c_details[0]
 
    cl_entity, cl_details =
      Person::ChurchLeader.add_entity_detail( { :first_name => "john" , :last_name => "jones" } )
    cl_detail= cl_details[0]
 
    c_detail.person_church_leader_details<< cl_detail
    c_detail.save

    assert_not_nil cl_detail.organization_church_detail
    assert_equal c_detail.person_church_leader_details.length, 1
  end

end
