class Curriculum::Base
  def self.grade_to_int(grade)

    return grade if grade.is_a? Fixnum
    r= if grade == 'K'
      0
    elsif grade == 'A'
      -2
    elsif grade == 'F'
      -2
    elsif grade == 'G'
      -2
    elsif grade == 'K'
      -2
    elsif grade == 'N'
      -2
    elsif grade == 'S'
      -2
    elsif (m = /(.*)-(.*)/.match(grade))
      m[1].to_i
    else
      grade.to_i
    end
  end

  def self.get_cpi ( ref )
    r = {}
    r[:klass_name] = klass_name = "Curriculum::CumulativeProgressIndicator"
    r[:cpi_ref] = ref
    r[:cpi] = cpi = klass_name.constantize.find_by_full_code(ref)
    r[:cpi_description] = cpi.description
    return r
  end

  def self.get_entry( ref_type , ref )
    r = nil
    r = get_cpi( ref ) if ref_type == "CPI"
    return r
  end

  def self.get_test_entry
    cpi = get_entry("CPI","NjS21clc 9.1.4.A.1")
  end

  def self.root_node
    CurriculumItem.get_curriculum_root_node(self)
  end

  def self.content_area
     self.root_node.target
  end

  def self.calc_by_end_of_grade
    self.content_area.calc_by_end_of_grade
  end

end
