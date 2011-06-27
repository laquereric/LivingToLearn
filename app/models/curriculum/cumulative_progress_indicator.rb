class Curriculum::CumulativeProgressIndicator < ActiveRecord::Base
  include CurriculumContent
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

  def full_spec()
    spec= {}
    spec[:cumulative_progress_indicator] = self
    if  spec[:curriculum_content_statement] = self.curriculum_content_statement
      if ( spec[:curriculum_strand] = spec[:curriculum_content_statement].curriculum_strand )
        if ( spec[:curriculum_standard] = spec[:curriculum_strand].curriculum_standard )
          if ( spec[:curriculum_content_area] = spec[:curriculum_standard].curriculum_content_area )
            spec[:curriculum] = spec[:curriculum_content_area].curriculum
            return spec
          end
        end
      end
    else
      nil
    end
    return nil
  end

  def deadline_range
    Curriculum::Grade.deadline_range(
      self
    )
 end

 def calc_full_code()
    spec= self.full_spec()
    return "" if !spec[:curriculum].respond_to?(:cumulative_progress_indicator__calc_full_code)
    return spec[:curriculum].cumulative_progress_indicator__calc_full_code(spec)
  end

  def destroy_wrapper
    p "destroying Cumulative Progress Indicator #{self.code} #{self.id}"
    self.delete
  end

end
