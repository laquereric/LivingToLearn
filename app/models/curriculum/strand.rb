class Curriculum::Strand < ActiveRecord::Base

  set_table_name :curriculum_strands

  before_save :set_full_code

  belongs_to :curriculum_standard, 
    :class_name => 'Curriculum::Standard',
    :foreign_key => "curriculum_standard_id"

  has_many :curriculum_content_statements,
    :class_name => 'Curriculum::ContentStatement',
    :foreign_key => "curriculum_strand_id",
    :dependent => :destroy

  def curriculum_content_statements_sorted_by_grade
    self.curriculum_content_statements.sort{ |x,y|
      Curriculum::CcParse.grade_to_int(x.by_end_of_grade) <=>
      Curriculum::CcParse.grade_to_int(y.by_end_of_grade)
    }
  end

  def curriculum_content_statements_sorted_by_grade_and_code
    self.curriculum_content_statements.sort{ |x,y|
      (100*Curriculum::CcParse.grade_to_int(x.by_end_of_grade))+x.code.to_i <=>
      (100*Curriculum::CcParse.grade_to_int(y.by_end_of_grade))+y.code.to_i
    }
  end

  scope :under_standard, lambda { |standard|
    where("curriculum_strands.curriculum_standard_id = ?", standard.id)
  }

  scope :with_code, lambda { |code|
    where("curriculum_strands.code = ?", code)
  }

  include ReportLine

#######
#
#######

  include ActionView::Helpers::UrlHelper
  include ActionController::UrlFor

  def link_to_details
    self.link_to 'link',"/curriculum_strands/#{self.id}"
  end

  def link_to_standard
    self.link_to 'link',"/curriculum_standards/#{self.curriculum_standard.id}"
  end

  def link_to_content_statements
    self.link_to 'link',"/curriculum_content_statements_for/#{self.id}"
  end

#######
#
#######

  def full_spec()
    spec= {}
      if ( spec[:curriculum_strand] = self )
        if ( spec[:curriculum_standard] = self.curriculum_standard )
          if ( spec[:curriculum_content_area] = spec[:curriculum_standard].curriculum_content_area )
            spec[:curriculum] = spec[:curriculum_content_area].curriculum
            return spec
          end
        end
      else
        nil
      end
      return nil
  end

  def calc_full_code()
    spec= self.full_spec()
    return "" if !spec[:curriculum].respond_to?(:strand__calc_full_code)
    return spec[:curriculum].strand__calc_full_code(spec)
  end

  def set_full_code
    self.full_code ||= self.calc_full_code
  end

  def reset_full_code
    self.full_code = self.calc_full_code
  end

  def destroy_wrapper
    p "destroying Curriculum Strand #{self.code}"
    self.curriculum_content_statements.each{ |cs|
      cs.destroy_wrapper
    }
    self.delete
  end

end
