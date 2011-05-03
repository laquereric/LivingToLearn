class AddCurriculumContentStatement < ActiveRecord::Migration
  def self.up
    rename_column "curriculum_cumulative_progress_indicators", :curriculum_strand_id , :curriculum_content_statement_id
 
    create_table "curriculum_content_statements", :force => true do |t|
      t.string   "code"
      t.string   "name"
      t.text     "description"
      t.string   "by_end_of_grade"
      t.integer  "curriculum_strand_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

  end

  def self.down
    rename_column "curriculum_cumulative_progress_indicators", :curriculum_content_statement_id, :curriculum_strand_id
    drop_table "curriculum_content_statements"
  end
end
