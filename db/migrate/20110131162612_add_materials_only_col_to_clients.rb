class AddMaterialsOnlyColToClients < ActiveRecord::Migration
  def self.up
    add_column "person_clients", :materials_only, :string
  end

  def self.down
    remove_column "person_clients", :materials_only
  end
end
