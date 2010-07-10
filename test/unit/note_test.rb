require 'test_helper'

class NoteTest < ActiveSupport::TestCase

  def setup
  end

  def test_new_should_create
    nd = Note.create :note => "a note"
    assert_not_nil nd
    assert_equal nd.errors.count , 0
  end

  def test_new_should_not_create_nil
    nd = Note.create
    assert_not_nil nd
    assert_equal nd.errors.count , 1
  end

end
