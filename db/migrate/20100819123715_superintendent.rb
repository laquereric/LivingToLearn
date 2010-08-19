class Superintendent < ActiveRecord::Migration
  def self.up
    create_table "person_superintendent", :force => true do |t|
      t.integer "entity_id"
      t.integer "total_schools"
      t.integer "ses_schools"
    end
  end

  def self.down
    drop_table "person_superintendent"
  end
end
