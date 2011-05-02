class Curriculum::Standard < ActiveRecord::Base

  set_table_name :curriculum_standards

  belongs_to :curriculum_content_area, 
    :class_name => 'Curriculum::ContentArea',
    :foreign_key => "curriculum_content_area_id"

  has_many :curriculum_strands, 
    :class_name => 'Curriculum::Strand',
    :foreign_key => "curriculum_standard_id",
    :dependent => :destroy

end
