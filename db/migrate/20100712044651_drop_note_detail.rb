class DropNoteDetail < ActiveRecord::Migration
  def self.up
    drop_table "note_detail"
  end

  def self.down
    create_table "note_detail", :force => true do |t|
      t.text     "note"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
