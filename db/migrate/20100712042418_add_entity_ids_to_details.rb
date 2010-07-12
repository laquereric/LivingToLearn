class AddEntityIdsToDetails < ActiveRecord::Migration
  def self.up

    add_column "cities", :entity_id, :integer
    add_column "counties", :entity_id, :integer
    add_column "countries", :entity_id, :integer
    add_column "neighborhoods", :entity_id, :integer
    add_column "school_districts", :entity_id, :integer
    add_column "states", :entity_id, :integer
    add_column "township_boros", :entity_id, :integer

  end

  def self.down

    remove_column "cities", :entity_id, :integer
    remove_column "counties", :entity_id, :integer
    remove_column "countries", :entity_id, :integer
    remove_column "neighborhoods", :entity_id, :integer
    remove_column "school_districts", :entity_id, :integer
    remove_column "states", :entity_id, :integer
    remove_column "township_boros", :entity_id, :integer

  end

end
