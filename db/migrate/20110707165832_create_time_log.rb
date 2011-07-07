class CreateTimeLog < ActiveRecord::Migration
  def self.up
  create_table "time_logs", :force => true do |t|
    t.string   "user_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string   "activity"
  end
  end

  def self.down
    drop_table "time_logs"
  end
end
