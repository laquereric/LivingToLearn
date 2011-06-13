require 'prawn'
require "prawn/measurement_extensions"

class Document::Reports::CcReadingOverview

  extend DocumentFilesBase

  def self.filename_base
    'CcMathOverview'
  end

  def self.report_filename()
    "#{self.filename_base}.report.pdf"
  end
####

  def self.physical_report_filename()
    File.join(self.physical_directory, self.report_filename() )
  end

 ###

  def self.public_report_filename()
    File.join(self.public_directory, self.report_filename() )
  end

  def self.report()
    Prawn::Document.generate( self.physical_report_filename ) do |pdf|
      first_page = true
      Curriculum::ContentArea.get_curiculum_by_type(Curriculum::CcReading){ |c_object|
        level = Curriculum::ContentArea.level_of(c_object)
        c_object.report_line(level)
      }
    end
    return []
  end

end

