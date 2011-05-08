class Curriculum::CharacterJi < Curriculum::ParseCsv

############
# Lower Level
#############
  def self.filename
    File.join(Rails.root,'data','character_ji.csv')
  end

  def self.content_area_key
    'CharacterJi'
  end

end

