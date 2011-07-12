class AddTreeFieldsToActivity < ActiveRecord::Migration

  def self.up
    add_column "activities","parent_id",:integer
    add_column "activities","lft",:integer
    add_column "activities","rgt",:integer
  end

  def self.down
    remove_column "activities","parent_id"
    remove_column "activities","lft"
    remove_column "activities","rgt"
  end
end
