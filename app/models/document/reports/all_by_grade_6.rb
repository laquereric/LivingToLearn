class Document::Reports::AllByGrade_6 < Document::Reports::AllByGrade

  def self.config
    self.target_grade= Curriculum::Grade.create({:cc_grade=>'6'})
  end

  def self.filename_base
    'CcByGrade6'
  end

end

