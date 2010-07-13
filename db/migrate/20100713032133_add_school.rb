class AddSchool < ActiveRecord::Migration
  def self.up
    create_table "government_schools", :force => true do |t|
      t.integer "school_district_id"
      t.integer "entity_id"
    end
  end

  def self.down
    drop_table "government_schools"
  end
end
