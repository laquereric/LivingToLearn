class AddPartner < ActiveRecord::Migration
  def self.up
    create_table "organization_partners", :force => true do |t|
      t.integer "entity_id"
      t.string "type"
    end
    create_table "person_partners", :force => true do |t|
      t.integer "entity_id"
      t.string "type"
    end
  end

  def self.down
    create_table "organization_partners"
    create_table "person_partners"
  end
end
