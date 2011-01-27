class CreateOrganizationTypes < ActiveRecord::Migration

  def self.up
    create_table "spreadsheet__living_to_learn__organization_types", :force => true do |t|
      t.string   :name
      t.string   :obf_1
      t.string   :obf_2
      t.string   :obf_3
    end
  end

  def self.down
    drop_table "spreadsheet__living_to_learn__organization_types"
  end
end
