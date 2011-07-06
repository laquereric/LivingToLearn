class Document::Reports::AllByGrade_4 < Document::Reports::AllByGrade

  def self.config
    self.target_grade= Curriculum::Grade.create({:cc_grade=>'4'})
  end

  def self.filename_base
    'CcByGrade4'
  end

end

