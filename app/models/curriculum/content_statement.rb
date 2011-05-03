class Curriculum::ContentStatement < ActiveRecord::Base

  set_table_name :curriculum_content_statements

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

end
