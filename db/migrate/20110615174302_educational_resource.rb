class EducationalResource < ActiveRecord::Migration
  def self.up
  create_table "educational_resources", :force => true do |t|
    t.integer  "res_id"
    t.integer  "parent_res_id"
    t.text     "cc_ref"
    t.text     "kind"
    t.text     "isbn"
    t.text     "web"
    t.text     "filepath"
    t.text     "page"
    t.text     "reference"
    t.text     "description"
    t.float    "dist_down"
    t.float    "dist_right"
    t.float    "height"
    t.float    "width"
    t.float    "dist_down"
    t.datetime "created_at"
    t.datetime "updated_at"
  end
  end

  def self.down
    drop_table "educational_resources"
  end

end
