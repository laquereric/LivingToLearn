class LivingToLearnMunicipalities < ActiveRecord::Migration
  def self.up
    create_table "spreadsheet__living_to_learn__municipalities", :force => true do |t|
      t.string :county
      t.string :municipality
      t.string :township_borough_city
    end
  end

  def self.down
    drop_table "spreadsheet__living_to_learn__municipalities"
  end
end
