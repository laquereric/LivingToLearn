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

  def self.cumulative_progress_indicator__calc_full_code(spec)
    "#{spec[:curriculum_content_area].code} #{spec[:curriculum_standard].code}.#{spec[:cumulative_progress_indicator].by_end_of_grade}.#{spec[:cumulative_progress_indicator].code}"
  end

end

