class Document::Reports::AllByGrade_12 < Document::Reports::AllByGrade

  def self.config
    self.target_grade= Curriculum::Grade.create({:cc_grade=>'12'})
  end

  def self.filename_base
    'CcByGrade12'
  end

end

