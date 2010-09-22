require 'test_helper'

class PersonParentPotnetialPayerTest < ActiveSupport::TestCase

  def setup
  end

  def test_should_be_able_to_add
    sda_entity, sda_details =
      Person::ParentPotentialPayer.add_entity_detail( { :first_name => "john" , :last_name => "jones" } )
    assert_equal sda_entity.errors.count, 0
    assert_equal sda_entity.entity_details.count , 1
    assert_equal sda_details.length , 1
  end

  def test_should_be_able_to_filter
    (1..5).each{ |i|
      sda_entity, sda_details =
        Person::ParentPotentialPayer.add_entity_detail( 
          { :first_name => "John#{i}" , :last_name => "Jones#{i}" }
        )
      sda_details[0].prospect_id= i
      sda_details[0].save
    }
    set= Person::ParentPotentialPayer.all
    assert_equal set.length , 5
    set= Person::ParentPotentialPayer.next_set(2,3)
    assert_equal set.length , 3
  end

end
