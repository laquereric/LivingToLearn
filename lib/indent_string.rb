module ReportLine

  def indent_string(indent=0)
    indent_string = ""; indent_string<< indent.times{ indent_string << ' ' }
    return indent_string
  end

  def report_line(indent=0)
    p "#{self.indent_string(indent)}#{self.class.to_s} #{self.code} #{self.name} #{self.description}"
  end

end

