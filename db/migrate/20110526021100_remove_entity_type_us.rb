class RemoveEntityTypeUs < ActiveRecord::Migration
  def self.up
    rename_column :subdomain_base, :entity_type, :entitytype
  end

  def self.down
    rename_column :subdomain_base, :entitytype, :entity_type
  end
end
