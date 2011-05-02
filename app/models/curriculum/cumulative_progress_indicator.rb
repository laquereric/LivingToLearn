class Curriculum::CumulativeProgressIndicator < ActiveRecord::Base

  set_table_name :curriculum_cumulative_progress_indicators
  belongs_to :curriculum_strand, 
    :class_name => 'Curriculum::Strand',
    :foreign_key => "curriculum_strand_id"

end
