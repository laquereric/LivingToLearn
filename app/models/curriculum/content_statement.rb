class Curriculum::ContentStatement < ActiveRecord::Base
  set_table_name :curriculum_content_statements
  has_one :curriculum_item, :as => "target_node_object"
  include CurriculumContent

  belongs_to :curriculum_strand, 
    :class_name => 'Curriculum::Strand',
    :foreign_key => "curriculum_strand_id",
    :dependent => :destroy

  has_many :cumulative_progress_indicators,
    :class_name => 'CumulativeProgressIndicator',
    :foreign_key => "curriculum_content_statement_id",
    :dependent => :destroy

  def find_or_create_cumulative_progress_indicator( cumulative_progress_indicator_config )
    cumulative_progress_indicators = self.cumulative_progress_indicators.select{ |cumulative_progress_indicator|
      cumulative_progress_indicator.code == cumulative_progress_indicator_config[:code]
    }
    cumulative_progress_indicator = if cumulative_progress_indicators.length == 0
      p "new cumulative_progress_indicator for #{self.id} : #{cumulative_progress_indicator_config.inspect}"
      self.cumulative_progress_indicators<< (n = Curriculum::CumulativeProgressIndicator.create(
         cumulative_progress_indicator_config)
      )
      n
    elsif  cumulative_progress_indicators.length == 1
      cumulative_progress_indicators[0]
    else
      p "Duplicate Curriculum::CumulativeProgressIndicator found #{cumulative_progress_indicator_config}"
      nil
    end
  end

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

  def destroy_wrapper
    p "Destroying Content Statement #{self.code}"
    self.cumulative_progress_indicators.each{ |cpi|
      cpi.destroy_wrapper
    }
    self.delete
  end

end

