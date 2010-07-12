class FixNotes < ActiveRecord::Migration
  def self.up
    drop_table "note_detail"
    add_column "notes", "entity_id", :integer
  end

  def self.down
  create_table "note_detail", :force => true do |t|
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end
  remove_column "notes", "entity_id"
 
  end
end
