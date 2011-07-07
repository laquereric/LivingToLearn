class Document::Reports::AllByGradePreK < Document::Reports::AllByGrade

  def self.config
    self.target_grade= Curriculum::Grade.create({:cc_grade=>'preK'})
  end

  def self.filename_base
    'CcByGradePreK'
  end

end

