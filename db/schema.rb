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

ActiveRecord::Schema.define(:version => 20100713032133) do

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
    t.string   "web_address"
    t.string   "wikipedia_address"
  end

  create_table "entity_details", :force => true do |t|
    t.string  "type"
    t.integer "entity_id"
    t.integer "detail_id"
    t.string  "detail_type"
  end

  create_table "government_cities", :force => true do |t|
    t.integer "township_boro_id"
    t.integer "government_id"
    t.integer "entity_id"
  end

  create_table "government_counties", :force => true do |t|
    t.integer "state_id"
    t.integer "entity_id"
  end

  create_table "government_countries", :force => true do |t|
    t.integer "entity_id"
  end

  create_table "government_neighborhoods", :force => true do |t|
    t.integer "city_id"
    t.integer "government_id"
    t.integer "entity_id"
  end

  create_table "government_school_districts", :force => true do |t|
    t.integer "county_id"
    t.integer "entity_id"
  end

  create_table "government_schools", :force => true do |t|
    t.integer "school_district_id"
    t.integer "entity_id"
  end

  create_table "government_states", :force => true do |t|
    t.integer "country_id"
    t.integer "entity_id"
  end

  create_table "government_township_boros", :force => true do |t|
    t.integer "county_id"
    t.integer "government_id"
    t.integer "entity_id"
  end

  create_table "locations", :force => true do |t|
    t.string  "street"
    t.string  "suite"
    t.string  "zip5"
    t.string  "zip4"
    t.integer "neighborhood_id"
    t.integer "city_id"
    t.integer "township_id"
    t.integer "school_dstrict_id"
    t.integer "county_id"
    t.integer "state_id"
    t.integer "country_id"
    t.integer "detail_id"
    t.string  "detail_type"
  end

  create_table "notes", :force => true do |t|
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "entity_id"
  end

end
