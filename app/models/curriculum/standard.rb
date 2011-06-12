class Curriculum::Standard < ActiveRecord::Base

  set_table_name :curriculum_standards

  before_save :set_full_code

  belongs_to :curriculum_content_area,
    :class_name => 'Curriculum::ContentArea',
    :foreign_key => "curriculum_content_area_id"

  has_many :curriculum_strands,
    :class_name => 'Curriculum::Strand',
    :foreign_key => "curriculum_standard_id",
    :dependent => :destroy

#######
#
#######

  include ActionView::Helpers::UrlHelper
  include ActionController::UrlFor

  def link_to_details
    self.link_to 'link',"/curriculum_standards/#{self.id}"
  end

  def link_to_content_area
    self.link_to 'link',"/curriculum_content_areas/#{self.curriculum_content_area.id}"
  end

  def link_to_strands
    self.link_to 'link',"/curriculum_strands_for/#{self.id}"
  end

#######
#
#######

  def find_strands_by_code( code )
    return self.curriculum_strands.select{ |s| s.code == code }
  end

  def calc_full_code()
    if curriculum_content_area
      "#{curriculum_content_area.code}_#{self.code}"
    else
      nil
    end
  end

  def set_full_code
     self.full_code ||= self.calc_full_code
  end

################
#
################

  def destroy_wrapper
    p "destroying Curriculum Standard #{self.code}"
    self.curriculum_strands.each{ |cs|
      cs.destroy_wrapper
    }
    self.destroy
  end

end
