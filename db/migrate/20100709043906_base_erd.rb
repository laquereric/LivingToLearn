class BaseErd < ActiveRecord::Migration
  def self.up

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

  end

  def self.down
    drop_table "entities"
  end
end
