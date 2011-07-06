class Document::Reports::AllByGrade_2 < Document::Reports::AllByGrade

  def self.config
    self.target_grade= Curriculum::Grade.create({:cc_grade=>'2'})
  end

  def self.filename_base
    'CcByGrade2'
  end

end

