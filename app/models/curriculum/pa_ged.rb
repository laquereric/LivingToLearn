class Curriculum::PaGed < Curriculum::ParseCsv

############
# Lower Level
#############
  def self.filename
    File.join(Rails.root,'data','pa_ged.csv')
  end

end

