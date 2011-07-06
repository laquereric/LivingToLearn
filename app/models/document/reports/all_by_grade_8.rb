class Document::Reports::AllByGrade_8 < Document::Reports::AllByGrade

  def self.config
    self.target_grade= Curriculum::Grade.create({:cc_grade=>'8'})
  end

  def self.filename_base
    'CcByGrade8'
  end

end

