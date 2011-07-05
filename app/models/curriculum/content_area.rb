class Curriculum::ContentArea < ActiveRecord::Base
  set_table_name :curriculum_content_areas
  has_one :curriculum_item, :as => "target_node_object"
  include CurriculumContent

  has_many :curriculum_standards,
    :class_name => 'Curriculum::Standard',
    :foreign_key => "curriculum_content_area_id",
    :dependent => :destroy

  def find_or_create_standard( standard_config )
    standards = self.curriculum_standards.select{ |standard|
      standard.code == standard_config[:code]
    }
    standard = if standards.length == 0
      p "new standard for #{self.id} #{standard_config.inspect}"
      self.curriculum_standards << (n = Curriculum::Standard.create(standard_config) )
      n
    elsif  standards.length == 1
      standards[0]
    else
      p "Duplicate Curriculum::Standards found #{standard_config[:code]}"
      nil
    end
  end

  def curriculum_standards_sorted_by_code
    self.curriculum_standards.sort{ |x,y|
        x.code <=> y.code
    }
  end

#######
#
#######

  include ReportLine

  include ActionView::Helpers::UrlHelper
  include ActionController::UrlFor

  def link_to_standards
    self.link_to 'link',"/curriculum_standards_for/#{self.id}"
  end

  def self.curriculum_class_list
    [ Curriculum::NjS21clc, Curriculum::CcMath,
      Curriculum::CcReading,Curriculum::CharacterJi
    ]
  end

  def curriculum_classname
    #TODO Should be column
    self.class.curriculum_class_list.each{ |obj|
      return obj.to_s if self.code == obj.content_area_key
    }
    p  "#{self.code} not found!"
    return nil
  end

#######
#
#######

  def link_to_details
    self.link_to 'link',"/curriculum_content_areas/#{self.id}"
  end

  def get_sorted_curriculum_standards
    return curriculum_standards.sort{ |x,y| x.code.to_i <=> y.code.to_i }
  end
  def self.level_of(ca_object)
    if ca_object.is_a? self
      0
    elsif ca_object.is_a? Curriculum::Standard
      1
    elsif ca_object.is_a? Curriculum::Strand
      2
    elsif ca_object.is_a? Curriculum::ContentStatement
      3
    elsif ca_object.is_a? Curriculum::CumulativeProgressIndicator
      4
    end
  end

end
