require 'test_helper'

class LocationsTest < ActiveSupport::TestCase

  def setup
  end

  def test_new_should_create
    l= Location.new
    assert_not_nil l

    e = Entity.create
    e.locations<< l
    assert e.locations.length, 1
  end

end
