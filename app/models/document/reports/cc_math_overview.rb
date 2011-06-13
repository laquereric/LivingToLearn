require 'prawn'
require "prawn/measurement_extensions"

class Document::Reports::CcMathOverview

  extend DocumentFilesBase

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

#############
# Report Hierarchy of Objects
#############

  def self.report_block(pdf,harray,index)
    pdf.indent(0.2.in){
      while true do

#############
# THIS object
#############

        break if index == harray.length

        c_object = harray[index][:object]
        level = harray[index][:level]

        return index if level.nil?
        line = c_object.report_line(0)
        pdf.font_size = 14-level
        pdf.text line

#############
# NEXT object
#############

        index += 1
        break if index == harray.length

        next_c_object = harray[index][:object]
        next_level = harray[index][:level]

        if next_level < level
          pdf.move_down(0.1.in)
          break
        elsif next_level == level
          pdf.move_down(0.05.in)
          next
        elsif next_level >= level
          pdf.move_down(0.2.in)
          index = self.report_block(pdf,harray,index)
        end

      end
    }
    return index
  end

###############
# Report
###############

  def self.filename_base
    'CcMathOverview'
  end

  def self.report()
    Prawn::Document.generate( File.join(Rails.root,"report") ) do |pdf|
      p "See #{self.physical_report_filename}"
      harray = []
      Curriculum::ContentArea.get_curiculum_by_type(Curriculum::CcMath){ |c_object|

        harray << {
          :object=> c_object,
          :level => Curriculum::ContentArea.level_of(c_object)
        }

      }
      self.report_block(pdf,harray,0)
    end
    return
  end

end

