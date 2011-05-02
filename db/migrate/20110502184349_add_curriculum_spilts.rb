class AddCurriculumSpilts < ActiveRecord::Migration

  def self.up
    add_column "curriculum_strands", :split , :float , :default => 0.0
  end

  def self.down
    remove_column "curriculum_strands", :split
  end

end
