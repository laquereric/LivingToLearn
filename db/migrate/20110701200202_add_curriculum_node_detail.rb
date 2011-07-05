class AddCurriculumNodeDetail < ActiveRecord::Migration
  def self.up
    add_column "curriculum_items", "cache", :text

    add_column "curriculum_items", "min_by_end_of_grade_age", :integer
    add_column "curriculum_items", "max_by_end_of_grade_age", :integer
    add_column "curriculum_items", "by_end_of_grade_age", :integer

    remove_column "curriculum_content_areas", "min_by_end_of_grade_age"
    remove_column "curriculum_standards", "min_by_end_of_grade_age"
    remove_column "curriculum_strands", "min_by_end_of_grade_age"

    remove_column "curriculum_content_areas", "max_by_end_of_grade_age"
    remove_column "curriculum_standards", "max_by_end_of_grade_age"
    remove_column "curriculum_strands", "max_by_end_of_grade_age"

  end

  def self.down

    remove_column "curriculum_items", "cache"
    remove_column "curriculum_items", "by_end_of_grade_age"
    remove_column "curriculum_items", "min_by_end_of_grade_age"
    remove_column "curriculum_items", "max_by_end_of_grade_age"
 
    add_column "curriculum_content_areas", "min_by_end_of_grade_age", :integer
    add_column "curriculum_standards", "min_by_end_of_grade_age", :integer
    add_column "curriculum_strands", "min_by_end_of_grade_age", :integer

    add_column "curriculum_content_areas", "max_by_end_of_grade_age", :integer
    add_column "curriculum_standards", "max_by_end_of_grade_age", :integer
    add_column "curriculum_strands", "max_by_end_of_grade_age", :integer

  end

end
