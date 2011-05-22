class Subdomain < ActiveRecord::Migration
  def self.up
  create_table "subdomain_base", :force => true do |t|
    t.string   "country"
    t.string   "state"
    t.string   "county"
    t.string   "city"
    t.string   "type"
    t.string   "name"
    t.string   "theme"
    t.string   "giveaway"
    t.string   "prize"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  end

  def self.down
    drop_table "subdomain_base"
  end
end
