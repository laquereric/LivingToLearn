require 'test_helper'

class EntityTest < ActiveSupport::TestCase

  def setup
  end

  def test_new_should_create
    e = Entity.create
    assert_not_nil e
  end

end
