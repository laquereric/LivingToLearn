require 'test_helper'

class PersonTest < ActiveSupport::TestCase

  def setup
  end

  def test_new_should_create
    ps = Person.create :first_name => "Joe", :last_name => "Smith"
    assert_not_nil ps
    assert_equal ps.errors.count , 0
  end

  def test_new_should_not_create_wo_last_name
    ps = Person.create :first_name => "Joe"
    assert_not_nil ps
    assert_equal ps.errors.count , 1
  end

   def test_new_should_not_create_wo_first_name
    ps = Person.create :last_name => "Smith"
    assert_not_nil ps
    assert_equal ps.errors.count , 1
  end

  def test_new_should_not_create_with_name
    ps = Person.create :first_name => "Joe", :last_name => "Smith", :name=>'urg name'
    assert_not_nil ps
    assert_equal ps.errors.count , 1
  end

end
