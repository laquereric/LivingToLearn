class AddCurriculumRoot < ActiveRecord::Migration
  def self.up

  create_table "curriculum_roots", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "full_code"
    t.string   "by_end_of_grade"
  end

  end

  def self.down
    drop_table "curriculum_roots"
  end
end
