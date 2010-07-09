require 'test_helper'

class EntityRelationshipTest < ActiveSupport::TestCase
  def setup
  end

  def test_new_should_create
    er = EntityRelationship.create
    assert_not_nil er
  end

  def test_should_allow_from_to
    e1 = Entity.create
    e2 = Entity.create
    er = EntityRelationship.new
    assert_nil er.from
    assert_nil er.to
    er.from = e1
    er.to = e2
    er_saved = er.save
    assert er_saved
    assert_equal er.errors.count, 0
    assert_equal er.from, e1 
    assert_equal er.to, e2 
  end

  def test_should_require_from
    e2 = Entity.create
    er = EntityRelationship.new
    er.to = e2
    er_saved = er.save
    assert !er_saved
    assert_equal er.errors.count, 1
  end

  def test_should_require_valid_from
    e2 = Entity.create
    er = EntityRelationship.new
    er.from_id = 9999
    er.to = e2
    er_saved = er.save
    assert !er_saved
    assert_equal er.errors.count, 1
  end
 
  def test_should_require_to
    e1 = Entity.create
    er = EntityRelationship.new
    er.from = e1
    er_saved = er.save
    assert !er_saved
    assert_equal er.errors.count, 1
  end
 
  def test_should_require_valid_to
    e1 = Entity.create
    er = EntityRelationship.new
    er.from = e1
    er.to_id = 9999
    er_saved = er.save
    assert !er_saved
    assert_equal er.errors.count, 1
  end
 
 end 
