class Curriculum::CumulativeProgressIndicator < ActiveRecord::Base

  set_table_name :curriculum_cumulative_progress_indicators

  belongs_to :curriculum_content_statement,
    :class_name => 'Curriculum::ContentStatement',
    :foreign_key => "curriculum_content_statement_id",
    :dependent => :destroy

  before_save :set_full_code

  def calc_full_code
    csta = self.curriculum_content_statement
    cstr = csta.curriculum_strand
    std = cstr.curriculum_standard
    ca = std.curriculum_content_area
    "#{ca.code} #{std.code}.#{self.by_end_of_grade}.#{self.code}"
  end

  def set_full_code
    self.full_code ||= self.calc_full_code
  end

end
