class Curriculum::Strand < ActiveRecord::Base

  set_table_name :curriculum_strands

  belongs_to :curriculum_standard, 
    :class_name => 'Curriculum::Standard',
    :foreign_key => "curriculum_standard_id"

  has_many :cumulative_progress_indicators,
    :class_name => 'Curriculum::Strand',
    :foreign_key => "curriculum_strand_id"

end
