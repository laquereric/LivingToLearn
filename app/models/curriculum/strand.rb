class Curriculum::Strand < ActiveRecord::Base

  set_table_name :curriculum_strands

  belongs_to :curriculum_standard, 
    :class_name => 'Curriculum::Standard',
    :foreign_key => "curriculum_standard_id"

  has_many :curriculum_content_statements,
    :class_name => 'Curriculum::ContentStatement',
    :foreign_key => "curriculum_strand_id",
    :dependent => :destroy

  scope :under_standard, lambda { |standard|
    where("curriculum_strands.curriculum_standard_id = ?", standard.id)
  }

  scope :with_code, lambda { |code|
    where("curriculum_strands.code = ?", code)
  }

end
