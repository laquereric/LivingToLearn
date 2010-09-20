class ParentPotentialPayer < ActiveRecord::Migration
  def self.up
    create_table "person_parent_potential_payer", :force => true do |t|
      t.integer "entity_id"
      t.integer "prospect_id"
      t.string "source"
      t.integer "government_school_entity_id"
      t.integer "government_school_district_entity_id"
    end
  end

  def self.down
    drop_table "person_parent_potential_payer"
  end

end
