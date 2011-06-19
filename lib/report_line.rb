module ReportLine

  def report_classname()
    self.class.to_s.split('::')[1].titleize
  end

  def report_by_grade()
    if self.respond_to? :by_end_of_grade
       "#{self.by_end_of_grade}"
    else
       ""
    end
  end

  def report_description()
    "#{self.name} #{self.description}"
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


