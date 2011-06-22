class AddCurriculumMapArc < ActiveRecord::Migration
  def self.up
    create_table "curriculum_map_arces", :force => true do |t|
      t.string  "secondary_curriculum_code"
      t.integer "educational_resource_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    rename_column "educational_resources", "cc_ref", "primary_curriculum_code"
  end

  def self.down
    drop_table "curriculum_map_arces"
    rename_column "educational_resources", "primary_curriculum_code","cc_ref"
  end
end
