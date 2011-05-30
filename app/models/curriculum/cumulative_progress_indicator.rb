class Curriculum::CumulativeProgressIndicator < ActiveRecord::Base
  set_table_name :curriculum_cumulative_progress_indicators

  belongs_to :curriculum_content_statement,
    :class_name => 'Curriculum::ContentStatement',
    :foreign_key => "curriculum_content_statement_id",
    :dependent => :destroy

  before_save :set_full_code

  def set_full_code
    self.full_code ||= self.calc_full_code
  end

  def calc_full_code()
     "#{self.curriculum_content_statement.full_code}_#{self.code}"
  end

end
