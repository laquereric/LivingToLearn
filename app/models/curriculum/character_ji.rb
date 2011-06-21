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

  def self.strand__calc_full_code(spec)
    "#{spec[:curriculum_content_area].code} #{spec[:curriculum_standard].code}.#{spec[:curriculum_strand].code}"
  end

end

