class Document::Reports::AllByGrade_1 < Document::Reports::AllByGrade

  def self.config
    self.target_grade= Curriculum::Grade.create({:cc_grade=>'1'})
  end

  def self.filename_base
    'CcByGrade1'
  end

end

