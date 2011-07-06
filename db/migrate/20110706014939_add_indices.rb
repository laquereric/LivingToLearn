class AddIndices < ActiveRecord::Migration
  def self.up

    add_index "curriculum_items","source_klass_name"
    add_index "curriculum_items","source_full_code"
    add_index "curriculum_items","target_node_object_type"
    add_index "curriculum_items","target_node_object_id"
    add_index "curriculum_items","parent_id"
    add_index "curriculum_items","lft"
    add_index "curriculum_items","rgt"
 
  end

  def self.down
    drop_index "curriculum_items","source_klass_name"
    drop_index "curriculum_items","source_full_code"
    drop_index "curriculum_items","target_node_object_type"
    drop_index "curriculum_items","target_node_object_id"
    drop_index "curriculum_items","parent_id"
    drop_index "curriculum_items","lft"
    drop_index "curriculum_items","rgt"
  end
end
