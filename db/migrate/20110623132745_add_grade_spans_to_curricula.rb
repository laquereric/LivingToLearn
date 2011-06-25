class AddGradeSpansToCurricula < ActiveRecord::Migration
  def self.up
    add_column "curriculum_standards", "by_end_of_grade", :string
    add_column "curriculum_content_areas", "by_end_of_grade", :string
    add_column "curriculum_strands", "by_end_of_grade", :string
  end

  def self.down
    remove_column "curriculum_standards", "by_end_of_grade"
    remove_column "curriculum_content_areas", "by_end_of_grade"
    remove_column "curriculum_strands", "by_end_of_grade"
  end

end
