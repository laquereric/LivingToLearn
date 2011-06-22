class CreateCurriculumItems < ActiveRecord::Migration
  def self.up
    create_table :curriculum_items do |t|
      t.string :source_klass_name
      t.string :source_full_code
      t.string :target_node_klass_name
      t.integer :target_node_object_id
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.timestamps
    end
  end

  def self.down
    drop_table :curriculum_items
  end
end
