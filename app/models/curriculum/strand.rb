class Curriculum::Strand < ActiveRecord::Base
  include CurriculumContent

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
      if !x.by_end_of_grade.nil? and !x.by_end_of_grade.nil?
        Curriculum::Grade.cc_grade_to_int(x.by_end_of_grade) <=>
        Curriculum::Grade.cc_grade_to_int(y.by_end_of_grade)
      else
        0<=>0
      end
    }
  end

  def curriculum_content_statements_sorted_by_grade_and_code
    self.curriculum_content_statements.sort{ |x,y|
      r = if !x.by_end_of_grade.nil? and !y.by_end_of_grade.nil? then
        x_cc_int = Curriculum::Grade.cc_grade_to_int(x.by_end_of_grade)
        y_cc_int = Curriculum::Grade.cc_grade_to_int(y.by_end_of_grade)
        if !x_cc_int.nil? and !y_cc_int.nil? and !x.code.nil? and !y.code.nil? then
          (100*x_cc_int) + x.code.to_i <=>
          (100*y_cc_int) + y.code.to_i
        else
          0<=>0
        end
      else
          0<=>0
      end
    }
  end

  def find_or_create_content_statement( content_statement_config )
    content_statements = self.curriculum_content_statements.select{ |content_statement|
      content_statement.code == content_statement_config[:code]
    }
    content_statement = if content_statements.length == 0
      p "new content_statement for #{self.id} : #{content_statement_config.inspect}"
      self.curriculum_content_statements<< ( n = Curriculum::ContentStatement.create(content_statement_config) )
      n
    elsif content_statements.length == 1
      content_statements[0]
    else
      p "Duplicate Curriculum::ContentStatement found #{content_statement_config}"
      nil
    end
  end

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

  def deadline_range
    Curriculum::Grade.deadline_range(
      self.curriculum_content_statements.map{ |curriculum_content_statement|
        curriculum_content_statement.deadline_range
      }
    )
  end

end
