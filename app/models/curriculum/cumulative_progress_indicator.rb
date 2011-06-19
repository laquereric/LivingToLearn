class Curriculum::CumulativeProgressIndicator < ActiveRecord::Base
  set_table_name :curriculum_cumulative_progress_indicators

  belongs_to :curriculum_content_statement,
    :class_name => 'Curriculum::ContentStatement',
    :foreign_key => "curriculum_content_statement_id"

  before_save :set_full_code

  include ReportLine

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

  def reset_full_code
    self.full_code = self.calc_full_code
  end

  def calc_full_code()
   if curriculum_content_statement
     if ( curriculum_strand = curriculum_content_statement.curriculum_strand )
       if ( curriculum_standard = curriculum_strand.curriculum_standard )
         if ( curriculum_content_area = curriculum_standard.curriculum_content_area )
           "#{curriculum_content_area.code} #{curriculum_standard.code}.#{curriculum_content_statement.by_end_of_grade}.#{self.code}"
         end
       end
     end
   else
      nil
   end
  end

  def destroy_wrapper
    p "destroying Cumulative Progress Indicator #{self.code} #{self.id}"
    self.delete
  end

end
