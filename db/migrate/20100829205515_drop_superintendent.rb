class DropSuperintendent < ActiveRecord::Migration
  def self.down
    create_table "person_superintendent", :force => true do |t|
      t.integer "entity_id"
      t.integer "total_schools"
      t.integer "ses_schools"
    end
  end

  def self.up
    drop_table "person_superintendent"
  end
end
