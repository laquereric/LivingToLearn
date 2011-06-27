class ChangeGradeSpansFieldOnCurricula < ActiveRecord::Migration
  def self.up
    remove_column "curriculum_standards", "by_end_of_grade"
    remove_column "curriculum_content_areas", "by_end_of_grade"
    remove_column "curriculum_strands", "by_end_of_grade"

    add_column "curriculum_standards", "min_by_end_of_grade_age", :integer
    add_column "curriculum_standards", "max_by_end_of_grade_age", :integer

    add_column "curriculum_content_areas", "min_by_end_of_grade_age", :integer
    add_column "curriculum_content_areas", "max_by_end_of_grade_age", :integer

    add_column "curriculum_strands", "min_by_end_of_grade_age", :integer
    add_column "curriculum_strands", "max_by_end_of_grade_age", :integer

  end

  def self.down
    add_column "curriculum_standards", "by_end_of_grade", :string
    add_column "curriculum_content_areas", "by_end_of_grade", :string
    add_column "curriculum_strands", "by_end_of_grade", :string  

    remove_column "curriculum_standards", "min_by_end_of_grade_age"
    remove_column "curriculum_standards", "max_by_end_of_grade_age"

    remove_column "curriculum_content_areas", "min_by_end_of_grade_age"
    remove_column "curriculum_content_areas", "max_by_end_of_grade_age"

    remove_column "curriculum_strands", "min_by_end_of_grade_age"
    remove_column "curriculum_strands", "max_by_end_of_grade_age"

  end
end
