class Service < ActiveRecord::Migration
  def self.up
  create_table "services", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end
  end

  def self.down
    drop_table "services"
  end
end
