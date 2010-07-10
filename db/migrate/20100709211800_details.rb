class Details < ActiveRecord::Migration
  
  def self.up
    create_table "entity_details", :force => true do |t|
      t.string   "type"
      t.integer  "entity_id"
      t.references :detail, :polymorphic => true
     end
 
     create_table "notes", :force => true do |t|
       t.text :note
       t.timestamps
     end
  end

  def self.down
    drop_table "entity_details"
    drop_table "notes"
  end

end
