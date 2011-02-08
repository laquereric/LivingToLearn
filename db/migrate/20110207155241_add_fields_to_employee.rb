class AddFieldsToEmployee < ActiveRecord::Migration

  def self.up
    add_column "person_employees", "sched_h", :string
    add_column "person_employees", "dur_h", :string

    add_column "person_employees", "sched_i", :string
    add_column "person_employees", "dur_i", :string
  end

  def self.down
    remove_column "person_employees", "sched_h", :string
    remove_column "person_employees", "dur_h", :string

    remove_column "person_employees", "sched_i", :string
    remove_column "person_employees", "dur_i", :string
  end

end
