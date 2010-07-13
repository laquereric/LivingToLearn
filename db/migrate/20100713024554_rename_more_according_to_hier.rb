class RenameMoreAccordingToHier < ActiveRecord::Migration
  def self.up
    rename_table "neighborhoods","government_neighborhoods"
    rename_table "school_districts","government_school_districts"
    rename_table "states","government_states"
    rename_table "township_boros","government_township_boros"
  end
  def self.down
    rename_table "government_neighborhoods","neighborhoods"
    rename_table "government_school_districts","school_districts"
    rename_table "government_states","states"
    rename_table "government_township_boros","township_boros"
   end
end
