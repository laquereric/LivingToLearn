class NormalizeGovernmentIds < ActiveRecord::Migration
  def self.up
    remove_column "government_cities", "government_id"
    remove_column "government_neighborhoods", "government_id"
    remove_column "government_township_boros", "government_id"
  end

  def self.down
    add_column "government_cities", "government_id",:integer
    add_column "government_neighborhoods", "government_id",:integer
    add_column "government_township_boros", "government_id",:integer
  end
end
