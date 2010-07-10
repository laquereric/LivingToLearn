require 'test_helper'

class OrganizationTest < ActiveSupport::TestCase

  def setup
  end

  def test_new_should_create
    ps = Organization.create :name => "Company"
    assert_not_nil ps
    assert_equal ps.errors.count , 0
  end

  def test_new_should_not_create_wo_name
    ps = Person.create :first_name => "Joe"
    assert_not_nil ps
    assert_equal ps.errors.count , 1
  end

   def test_new_should_not_create_w_first_name
    ps = Person.create :name => "Company", :first_name => "Smith"
    assert_not_nil ps
    assert_equal ps.errors.count , 2
  end

  def test_new_should_not_create_w_last_name
    ps = Person.create  :name => "Company", :last_name => "Smith"
    assert_not_nil ps
    assert_equal ps.errors.count , 2
  end

end
