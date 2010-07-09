class BaseErd2 < ActiveRecord::Migration
  def self.up
    create_table "entity_relationships", :force => true do |t|
      t.string   "type"
      t.integer  "from_id"
      t.integer  "to_id"
     end
  end

  def self.down
    drop_table "entity_relationships"
  end
end
