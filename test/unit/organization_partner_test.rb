require 'test_helper'

class OrganizationPartnerTest < ActiveSupport::TestCase

  def setup
  end

  def test_should_be_able_to_add
    organization_entity , organization_details =
      Organization::Partner.add_entity_detail( { :name => "Boys and Girls Club of Gloucester County" } )
    assert_equal organization_entity.errors.count, 0
    assert_equal organization_entity.entity_details.count , 1
    assert_equal organization_details.length , 1
  end

  def test_should_not_be_able_to_add_wo_name
    organization_entity , organization_details =
      Organization::Partner.add_entity_detail( {} )
    assert_not_equal organization_entity.errors.count, 0
  end

  def test_should_be_able_to_find_or_add_name_wo_dup
    organization_entity , organization_details =
      Organization::Partner.find_or_add_name_details( "New Jersey", {} )
    assert_equal Organization::Partner.count, 1
    organization_entity , organization_details =
      Organization::Partner.find_or_add_name_details( "New Jersey", {} )
    assert_equal Organization::Partner.count, 1
  end

end
