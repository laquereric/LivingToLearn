class SchoolDistrictAdminstrator < ActiveRecord::Migration

  def self.up
    create_table "person_school_district_administrator", :force => true do |t|
      t.integer "entity_id"
      t.integer "government_school_district_entity_id"
    end
  end

  def self.down
    drop_table "person_school_district_administrator"
  end

end
