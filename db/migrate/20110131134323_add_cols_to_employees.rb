class AddColsToEmployees < ActiveRecord::Migration
  def self.up
    add_column "person_employees", :records_only, :string
    add_column "person_employees", :lump_sum, :string
  end

  def self.down
    remove_column "person_employees", :records_only
    remove_column "person_employees", :lump_sum
  end
end
