class AddActivities < ActiveRecord::Migration
  def self.up
    create_table "activities", :force => true do |t|
      t.string   "user_email"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "name"
    end
  end

  def self.down
    drop_table "activities"
  end
end
