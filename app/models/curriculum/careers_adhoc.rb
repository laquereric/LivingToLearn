class Curriculum::CareersAdhoc < Curriculum::ParseCsv

############
# Lower Level
#############
  def self.filename
    File.join(Rails.root,'data','careers_adhoc.csv')
  end

  def self.content_area_key
    'CareersAdhoc'
  end

end

