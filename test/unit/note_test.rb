require 'test_helper'

class NoteTest < ActiveSupport::TestCase

  def setup
  end

  def test_should_be_able_to_note
    e = Entity.create
    note= e.add_detail( Note, {:note => "a note"} )
    assert_equal e.entity_details.count , 1
    assert_not_nil note.entity_detail
  end

end
