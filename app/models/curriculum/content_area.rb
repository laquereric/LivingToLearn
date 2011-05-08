class Curriculum::ContentArea < ActiveRecord::Base

  set_table_name :curriculum_content_areas

  has_many :curriculum_standards, 
    :class_name => 'Curriculum::Standard',
    :foreign_key => "curriculum_content_area_id",
    :dependent => :destroy

  def get_curriculum_standards( filter = {} )
    results = curriculum_standards.sort{ |x,y| x.code.to_i <=> y.code.to_i }
    if ( curriculum_standard_code = filter[:curriculum_standard_code] )
      results = results.select{ |s|  s.code == curriculum_standard_code }
    end
    return results
  end

end
