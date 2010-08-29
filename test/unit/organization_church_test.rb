require 'test_helper'

class OrganizationChurchTest < ActiveSupport::TestCase

  def setup
  end

  def test_should_be_able_to_add
    c_entity, c_details =
      Organization::Church.add_entity_detail( { :name => "Big Church" } )
    assert_equal c_entity.errors.count, 0
    assert_equal c_entity.entity_details.count , 1
    assert_equal c_details.length , 1
  end

end
