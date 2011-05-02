class CurriculumClasses < ActiveRecord::Migration

  def self.up

  create_table "curriculum_content_areas", :force => true do |t|
    t.string   :code
    t.string   :name
    t.text     :description
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "curriculum_standards", :force => true do |t|
    t.string   :code
    t.string   :name
    t.text     :description
    t.integer  :curriculum_content_area_id
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "curriculum_strands", :force => true do |t|
    t.string   :code
    t.string   :name
    t.text     :description
    t.integer  :curriculum_standard_id
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "curriculum_cumulative_progress_indicators", :force => true do |t|
    t.string   :code
    t.string   :name
    t.text     :description
    t.string   :by_end_of_grade
    t.integer  :curriculum_strand_id
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  end

  def self.down
    drop_table "curriculum_content_areas"
    drop_table "curriculum_standards"
    drop_table "curriculum_strands"
    drop_table "curriculum_cumulative_progress_indicators"
  end

end
