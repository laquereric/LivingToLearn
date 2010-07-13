class RenameTablesAccordingToHier < ActiveRecord::Migration

  def self.up
    rename_table "cities", "government_cities"
    rename_table "counties", "government_counties"
    rename_table "countries", "government_countries"
  end

  def self.down
    rename_table "government_cities",  "cities"
    rename_table "government_counties", "counties"
    rename_table "government_countries",  "countries"
  end

end
