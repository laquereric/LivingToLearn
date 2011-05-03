class Curriculum::CumulativeProgressIndicator < ActiveRecord::Base

  set_table_name :curriculum_cumulative_progress_indicators

  belongs_to :curriculum_content_statement,
    :class_name => 'Curriculum::ContentStatement',
    :foreign_key => "curriculum_content_statement_id",
    :dependent => :destroy

  def full_code
    cs = self.curriculum_strand
    std = cs.curriculum_standard
    ca = std.curriculum_content_area
    "#{ca.code} #{std.code}.#{self.by_end_of_grade}.#{self.code}"
  end
end
