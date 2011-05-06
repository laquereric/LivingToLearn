class Curriculum::CharacterJi < Curriculum::ParseCsv

############
# Lower Level
#############
  def self.filename
    File.join(Rails.root,'data','character_ji.csv')
  end

end

