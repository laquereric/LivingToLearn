class Document::Reports::CharacterJiOverview < Document::Reports::CcOverview

  def self.public_report_filename()
    File.join(self.public_directory, self.report_filename() )
  end

  def self.curriculum_class
    Curriculum::CharacterJi
  end

  def self.filename_base
    'CharacterJiOverview'
  end

end

