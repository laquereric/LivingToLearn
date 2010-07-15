require 'test_helper'

class GovernmentStateTest < ActiveSupport::TestCase

  def setup
  end

  def test_should_be_able_to_add
    st= Government::State.add( { :name => "New Jersey" } )
    assert_equal st.errors.count, 0
    assert_equal st.entity_details.count , 1
  end

  def test_should_not_be_able_to_add_wo_name
    st= Government::State.add( {} )
    assert_not_equal st.errors.count, 0
  end

end
