class AddSchoolDistrictEmployerToEmployye < ActiveRecord::Migration
  def self.up
    add_column "person_employees", :school_district_employer, :string
  end

  def self.down
    remove_column "person_employees", :school_district_employer
  end
end
