class Curriculum::ContentArea < ActiveRecord::Base

  set_table_name :curriculum_content_areas

  has_many :curriculum_standards, 
    :class_name => 'Curriculum::Standard',
    :foreign_key => "curriculum_content_area_id",
    :dependent => :destroy

  def get_sorted_curriculum_standards
    return curriculum_standards.sort{ |x,y| x.code.to_i <=> y.code.to_i }
  end

  def find_standards_by_code( code )
    return self.curriculum_standards.select{ |s| s.code == code }
  end

end
