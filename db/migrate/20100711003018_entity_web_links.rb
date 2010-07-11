class EntityWebLinks < ActiveRecord::Migration
  def self.up
    add_column "entities", "web_address", :string
    add_column "entities", "wikipedia_address", :string
  end

  def self.down
    drop_column "entities", "web_address", :string
    drop_column "entities", "wikipedia_address", :string
  end
end
