class AddPrimaryTutorForCurrentClients < ActiveRecord::Migration
  def self.up
    add_column "person_clients", "primary_tutor",:string
  end

  def self.down
    remove_column "person_clients", "primary_tutor"
  end
end
