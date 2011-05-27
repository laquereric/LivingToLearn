class AddContexts < ActiveRecord::Migration
  def self.up
  create_table "contexts", :force => true do |t|
    t.text     "user_email"
    t.text     "topic"
    t.text     "service"
    t.text     "marketing"
    t.text     "subdomain_path"
    t.text     "ref_type"
    t.text     "ref_field"
    t.text     "ref_value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end
  end

  def self.down
  end
end
