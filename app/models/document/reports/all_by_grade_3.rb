class Document::Reports::AllByGrade_3 < Document::Reports::AllByGrade

  def self.config
    self.target_grade= Curriculum::Grade.create({:cc_grade=>'3'})
  end

  def self.filename_base
    'CcByGrade3'
  end

end

