# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100709211800) do

  create_table "entities", :force => true do |t|
    t.string   "type"
    t.string   "prefix"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "suffix"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "entity_details", :force => true do |t|
    t.string  "type"
    t.integer "entity_id"
    t.integer "detail_id"
    t.string  "detail_type"
  end

  create_table "entity_relationships", :force => true do |t|
    t.string  "type"
    t.integer "from_id"
    t.integer "to_id"
  end

  create_table "note_detail", :force => true do |t|
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notes", :force => true do |t|
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
