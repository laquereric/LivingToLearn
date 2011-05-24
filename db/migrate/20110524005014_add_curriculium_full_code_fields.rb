class AddCurriculiumFullCodeFields < ActiveRecord::Migration
  def self.up
    add_column "curriculum_content_areas", 'full_code',:string
    add_column "curriculum_content_statements", 'full_code',:string
    #add_column "curriculum_cumulative_progress_indicators",'full_code',:string
    add_column "curriculum_standards", 'full_code',:string
    add_column "curriculum_strands", 'full_code',:string
  end

  def self.down
    remove_column "curriculum_content_areas", 'full_code',:string
    remove_column "curriculum_content_statements", 'full_code',:string
    #remove_column "curriculum_cumulative_progress_indicators",'full_code',:string
    remove_column "curriculum_standards", 'full_code',:string
    remove_column "curriculum_strands", 'full_code',:string
  end
end
