class EducationEvents < ActiveRecord::Migration
  def self.up

   create_table "education_events", :force => true do |t|
    t.string  "client_id"
    t.string  "first_name"
    t.string  "last_name"
    t.string  "date"
    t.string  "event"
    t.string "result"
    t.string  "note"
   end

  end

  def self.down
  end
end
