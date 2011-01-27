class CreateObjectivesBenefitsFeature < ActiveRecord::Migration
  def self.up
create_table "spreadsheet__living_to_learn__objectives_benefits_features", :force => true do |t|
t.string   :name
t.string   :objective
t.string   :benefit
t.string   :feature
end
  end

  def self.down
create_table "spreadsheet__living_to_learn__objectives_benefits_features"
  end
end
