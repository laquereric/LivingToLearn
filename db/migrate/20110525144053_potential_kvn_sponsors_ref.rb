class PotentialKvnSponsorsRef < ActiveRecord::Migration
  def self.up
    add_column :subdomain_base, :ref_type, :string
    add_column :subdomain_base, :ref_field, :string
    add_column :subdomain_base, :ref_value, :string
  end

  def self.down
    remove_column :subdomain_base, :ref_type
    remove_column :subdomain_base, :ref_field
    remove_column :subdomain_base, :ref_value
  end
end
