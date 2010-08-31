class SchoolDistrictAndEntityFixes < ActiveRecord::Migration
  def self.up
    add_column "government_school_districts", :status, :string
  end

  def self.down
  end
end
