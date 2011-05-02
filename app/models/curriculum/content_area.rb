class Curriculum::ContentArea < ActiveRecord::Base

  set_table_name :curriculum_content_areas

  has_many :curriculum_standards, 
    :class_name => 'Curriculum::Standard',
    :foreign_key => "curriculum_content_area_id",
    :dependent => :destroy

end
