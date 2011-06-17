module ReportLine

  def indent_string(indent=0)
    indent_string = ""; indent.times{ indent_string << ' ' }
    return indent_string
  end

  def report_line(indent=0)
    l = []
    l << "#{self.indent_string(indent)}"
    l << "#{self.class.to_s.split('::')[1]} "
    if self.respond_to? :by_end_of_grade
      l << "Grade #{self.by_end_of_grade} "
    else
      l << " "
    end
    l << " "
    l << "#{self.code} "
    l << "#{self.name} "
    l << "#{self.description}"
  end
end


