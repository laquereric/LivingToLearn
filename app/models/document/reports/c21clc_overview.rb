class Document::Reports::C21clcOverview < Document::Reports::CcOverview

  def self.public_report_filename()
    File.join(self.public_directory, self.report_filename() )
  end

  def self.curriculum_class
    Curriculum::NjS21clc
  end

  def self.filename_base
    'C21clcOverview'
  end

end

