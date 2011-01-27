class AddOrganizationTypeToMember < ActiveRecord::Migration
  def self.up
    add_column 'spreadsheet__living_to_learn__organization_members', :organization_type, :string
    add_column 'spreadsheet__living_to_learn__organization_members', :organization_id, :string
    add_column 'spreadsheet__living_to_learn__organization_members', :parent_organization_id, :string
  end

  def self.down
    remove_column 'spreadsheet__living_to_learn__organization_members', :organization_type
    remove_column 'spreadsheet__living_to_learn__organization_members', :organization_id
    remove_column 'spreadsheet__living_to_learn__organization_members', :parent_organization_id
  end
end
