class RenameCurriculumItemTypeCol < ActiveRecord::Migration
  def self.up
    rename_column "curriculum_items", "target_node_klass_name","target_node_object_type"
  end

  def self.down
    rename_column "curriculum_items","target_node_object_type", "target_node_klass_name"
  end
end
