class Document::Reports::AllByGrade_5 < Document::Reports::AllByGrade

  def self.config
    self.target_grade= Curriculum::Grade.create({:cc_grade=>'5'})
  end

  def self.filename_base
    'CcByGrade5'
  end

end

