class Document::Reports::AllByGrade_7 < Document::Reports::AllByGrade

  def self.config
    self.target_grade= Curriculum::Grade.create({:cc_grade=>'7'})
  end

  def self.filename_base
    'CcByGrade7'
  end

end

