class DropEntityRelationship < ActiveRecord::Migration
  def self.up
    drop_table "entity_relationships"
  end

  def self.down
    create_table "entity_relationships", :force => true do |t|
      t.string  "type"
      t.integer "from_id"
      t.integer "to_id"
    end
  end
end
