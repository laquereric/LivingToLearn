class Document::Reports::AllByGradeK < Document::Reports::AllByGrade

  def self.config
    self.target_grade= Curriculum::Grade.create({:cc_grade=>'K'})
  end

  def self.filename_base
    'CcByGradeK'
  end

end

