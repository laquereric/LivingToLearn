class Curriculum::NjStandards < Curriculum::ParseCsv

############
# Lower Level
#############
  def self.filename
    File.join(Rails.root,'data','nj_standards.csv')
  end

end

