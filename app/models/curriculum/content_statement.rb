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

   def calc_full_code()
     "#{self.curriculum_strand.full_code}_#{self.code}"
   end

   def set_full_code
     self.full_code ||= self.calc_full_code
   end

   def by_end_of_grade_clean
     if self.by_end_of_grade then self.by_end_of_grade else 'not specified' end
   end

end
