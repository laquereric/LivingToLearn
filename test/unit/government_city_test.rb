require 'test_helper'

class GovernmentCityTest < ActiveSupport::TestCase

  def setup
  end

  def test_should_be_able_to_add
    cy= Government::City.add( { :name => "Sewell" } )
    assert_equal cy.errors.count, 0
    assert_equal cy.entity_details.count , 1
  end

  def test_should_not_be_able_to_add_wo_name
    cy= Government::City.add( {} )
    assert_not_equal cy.errors.count, 0
  end

end
