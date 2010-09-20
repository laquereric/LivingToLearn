class ChangeLocation < ActiveRecord::Migration
  def self.up
    rename_column "locations", "street", "address_line1"
    rename_column "locations", "suite", "address_line2"
    rename_column "locations", "zip5", "zip"
    rename_column "locations", "school_dstrict_id", "school_district_id"
    add_column "locations", "entity_id", :string
    add_column "locations", "city", :string
    add_column "locations", "state", :string
 end

  def self.down
    rename_column "locations","address_line1","street"
    rename_column "locations","address_line2","suite"
    rename_column "locations","zip","zip5"
    rename_column "locations","school_district_id","school_dstrict_id"
    remove_column "locations", "entity_id"
    remove_column "locations", "city"
    remove_column "locations", "state"
  end
end
