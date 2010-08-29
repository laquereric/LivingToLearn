class ChurchesAndChurchLeaders < ActiveRecord::Migration

  def self.up

    create_table "person_church_leaders", :force => true do |t|
      t.integer "entity_id"
      t.integer "organization_church_detail_id"
    end

    create_table "organization_churches", :force => true do |t|
      t.integer "entity_id"
    end

  end

  def self.down
    drop_table "person_church_leaders"
    drop_table "organization_churches"
  end

end
