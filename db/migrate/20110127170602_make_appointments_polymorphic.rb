class MakeAppointmentsPolymorphic < ActiveRecord::Migration
  def self.up
    rename_column "appointments", "client_id", "appointable_id"
    add_column "appointments", "appointable_type", :string
  end

  def self.down
    rename_column "appointments", "appointable_id", "client_id"
    remove_column "appointments", "appointable_type", :string
  end
end
