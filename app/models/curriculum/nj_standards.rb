class Curriculum::NjStandards < Curriculum::ParseCsv

############
# Lower Level
#############
  def self.filename
    File.join(Rails.root,'data','nj_21clc.csv')
  end

  def self.content_area_key
    'NJ_21CLC'
  end

end

