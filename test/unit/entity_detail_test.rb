require 'test_helper'

class EntityDetailTest < ActiveSupport::TestCase

  def setup
  end

  def test_new_should_create
    edd = EntityDetail.create
    assert_not_nil edd
    assert_equal edd.errors.count , 2
  end

  def test_should_be_able_to_note
    e = Entity.create
    n = Note.create :note => "a note"
    edd = EntityDetail.new
    edd.entity = e
    edd.detail = n
    edd.save
    assert_not_nil edd
    assert_equal edd.errors.count , 0
  end

end
