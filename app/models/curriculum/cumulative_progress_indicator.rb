class Curriculum::CumulativeProgressIndicator < ActiveRecord::Base
  set_table_name :curriculum_cumulative_progress_indicators
  has_one :curriculum_item, :as => "target_node_object"
  include CurriculumContent

  belongs_to :curriculum_content_statement,
    :class_name => 'Curriculum::ContentStatement',
    :foreign_key => "curriculum_content_statement_id"

  include ReportLine

  include ActionView::Helpers::UrlHelper
  include ActionController::UrlFor

  def link_to_details
    self.link_to 'link',"/curriculum_cumulative_progress_indicators/#{self.id}"
  end

  def link_to_curriculum_content_statement
    self.link_to 'link',"/curriculum_content_statements/#{self.curriculum_content_statement.id}"
  end

  def destroy_wrapper
    p "destroying Cumulative Progress Indicator #{self.code} #{self.id}"
    self.delete
  end

end
