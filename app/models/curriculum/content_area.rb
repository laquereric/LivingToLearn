class Curriculum::ContentArea < ActiveRecord::Base

  set_table_name :curriculum_content_areas

  before_save :set_full_code

  has_many :curriculum_standards,
    :class_name => 'Curriculum::Standard',
    :foreign_key => "curriculum_content_area_id",
    :dependent => :destroy

#######
#
#######

  include ActionView::Helpers::UrlHelper
  include ActionController::UrlFor

  def link_to_standards
    self.link_to 'link',"/curriculum_standards_for/#{self.id}"
  end

#######
#
#######
  def link_to_details
    self.link_to 'link',"/curriculum_content_areas/#{self.id}"
  end

  def curriculum_content_area_id
    self.id
  end

  def get_sorted_curriculum_standards
    return curriculum_standards.sort{ |x,y| x.code.to_i <=> y.code.to_i }
  end

  def find_standards_by_code( code )
    [Curriculum::Standard.find_by_full_code("#{self.code}_#{code}")]
  end

  def calc_full_code()
    self.code
  end

  def set_full_code
     self.full_code ||= self.calc_full_code
  end

  def self.find_by_full_code(code)
    ca = code.split('_')
    r = if ca.length == 1
      self.find_by_full_code(code)
    elsif  ca.length == 2
      Curriculum::Standard.find_by_full_code(code)
    elsif  ca.length == 3
      Curriculum::Strand.find_by_full_code(code)
    elsif  ca.length == 4
      Curriculum::ContentStatement.find_by_full_code(code)
    elsif  ca.length == 5
      Curriculum::CumulativeProgressIndicator.find_by_full_code(code)
    end
  end

  def all_strands()
    self.curriculum_standards.map{ |standard| standard.curriculum_strands }.flatten
  end

  def all_strand_full_codes
    all_strands.map{ |s| s.full_code }
  end

  def self.set_full_codes()
    self.all.each{ |r| r.set_full_code; r.save; p r}
    Curriculum::Standard.all.each{ |r| r.set_full_code;r.save;p r}
    Curriculum::Strand.all.each{ |r| r.set_full_code;r.save;p r}
    Curriculum::ContentStatement.all.each{ |r| r.set_full_code;r.save;p r}
    Curriculum::CumulativeProgressIndicator.all.each{ |r| r.set_full_code;r.save;p r}
  end

  def self.find_by_full_code(code)
    ca = code.split('_')
    r = if ca.length == 1
      self.find_by_full_code(code)
    elsif  ca.length == 2
      Curriculum::Standard.find_by_full_code(code)
    elsif  ca.length == 3
      Curriculum::Strand.find_by_full_code(code)
    elsif  ca.length == 4
      Curriculum::ContentStatement.find_by_full_code(code)
    elsif  ca.length == 5
      Curriculum::CumulativeProgressIndicator.find_by_full_code(code)
    end
  end

end
