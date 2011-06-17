class Curriculum::NjS21clc < Curriculum::ParseCsv

############
# Lower Level
#############
  def self.filename
    File.join(Rails.root,'data','nj_s21clc.csv')
  end

  def self.content_area_key
    'NjS21clc'
  end

end

