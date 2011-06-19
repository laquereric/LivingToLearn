class Curriculum::ContentStatement < ActiveRecord::Base

  set_table_name :curriculum_content_statements

  before_save :set_full_code

  belongs_to :curriculum_strand, 
    :class_name => 'Curriculum::Strand',
    :foreign_key => "curriculum_strand_id",
    :dependent => :destroy

  has_many :cumulative_progress_indicators,
    :class_name => 'CumulativeProgressIndicator',
    :foreign_key => "curriculum_content_statement_id",
    :dependent => :destroy

  scope :with_description, lambda { |description|
     where("curriculum_content_statements.description = ?", description)
  }

  scope :by_end_of_grade_equals, lambda { |by_end_of_grade|
     where("curriculum_content_statements.by_end_of_grade = ?", by_end_of_grade)
  }

  include ReportLine

#######
#
#######

  include ActionView::Helpers::UrlHelper
  include ActionController::UrlFor

  def link_to_details
    self.link_to 'link',"/curriculum_content_statements/#{self.id}"
  end

  def link_to_strand
    self.link_to 'link',"/curriculum_strands/#{self.curriculum_strand.id}"
  end

  def link_to_cumulative_progress_indicators
    self.link_to 'link',"/curriculum_cumulative_progress_indicators_for/#{self.id}"
  end

#######
#
#######
  def reset_full_code
    self.full_code = self.calc_full_code
  end

  def calc_full_code()
    ""
  end

  def set_full_code
    self.full_code ||= self.calc_full_code
  end

  def by_end_of_grade_clean
    if self.by_end_of_grade then self.by_end_of_grade else 'not specified' end
  end

  def destroy_wrapper
    p "Destroying Content Statement #{self.code}"
    self.cumulative_progress_indicators.each{ |cpi|
      cpi.destroy_wrapper
    }
    self.delete
  end

end
