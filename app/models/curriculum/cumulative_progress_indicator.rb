class Curriculum::CumulativeProgressIndicator < ActiveRecord::Base
  set_table_name :curriculum_cumulative_progress_indicators

  belongs_to :curriculum_content_statement,
    :class_name => 'Curriculum::ContentStatement',
    :foreign_key => "curriculum_content_statement_id",
    :dependent => :destroy

  before_save :set_full_code

  include ActionView::Helpers::UrlHelper
  include ActionController::UrlFor

  def link_to_details
    self.link_to 'link',"/curriculum_cumulative_progress_indicators/#{self.id}"
  end

  def link_to_curriculum_content_statement
    self.link_to 'link',"/curriculum_content_statements/#{self.curriculum_content_statement.id}"
  end

  def set_full_code
    self.full_code ||= self.calc_full_code
  end

  def calc_full_code()
   if curriculum_content_statement
     "#{self.curriculum_content_statement.full_code}_#{self.code}"
   else
      nil
   end
  end

end
