require 'prawn'
require "prawn/measurement_extensions"

class Document::Letter::EducationStatus < Document::Letter::TwoWindowTemplate

  cattr_accessor :education_event_array

###############################
# Files
###############################
  def self.local_directory
    dn = File.join(ENV['ARCHIVED_COMMUNICATIONS_DIR'],"education_reports")
    Dir.mkdir(dn) if !File.exists?(dn)
    return dn
  end

###############################
# Layout
###############################

  def self.body_bounding_box( doc , &block )

    body_top_left = [ doc.bounds.left+0.5.in , doc.bounds.top - 3.25.in ]
    body_width = doc.bounds.width-1.0.in
    body_height = 6.75.in

    doc.bounding_box( body_top_left, :width => body_width, :height => body_height ) {
      #doc.stroke_bounds
      doc.move_down(0.125.in)
      doc.indent(0.125.in){
        yield(doc)
      }
   }
  
  end

  def self.table_bounding_box( doc , &block )

    body_top_left = [ doc.bounds.left+0.5.in , doc.bounds.top - 3.25.in ]
    body_width = doc.bounds.width-1.0.in
    body_height = 6.75.in

    doc.bounding_box( body_top_left, :width => body_width, :height => body_height ) {
      #doc.stroke_bounds
      doc.move_down(0.125.in)
      doc.indent(0.125.in){
        yield(doc)
      }
   }
  
  end


  def self.header_for(doc,school_district,client)

    doc.fill_color "0055DD"
    doc.font_size = 12
    doc.text "SES Tutoring Status"


=begin
    doc.move_down(0.125.in)
    doc.text "Personalized educational materials "
    doc.text "and a tutor were available for"
    doc.indent(0.125.in){
    doc.text "#{client[:first_name]} #{client[:last_name]} on #{next_date.datetime.strftime( '%a %b %d at %I:%M %P' ) } in #{next_date.location_code}", :style=>:bold
  }
    doc.move_down(0.125.in)
    doc.text "In this session, he/she", :style=>:bold
    doc.move_down(0.125.in)
    doc.text "[  ] was present for tutoring"
    doc.text " "
    doc.text "[  ]  was not present for tutoring"
    doc.text " "
=end

  end

  def self.body_for(doc,school_district,client)

    doc.font_size = 4
    doc.fill_color "000000"
doc.text "As part of the #{school_district.pretty_name} Supplemental Education Services (SES) program, your student is enrolled to receive tutoring from the Tutoring Club."
    doc.move_down(0.125.in)
    doc.text "This note is your record of his or her attendance. The box at the top of this page indicates whether they were present for this scheduled session."
    doc.move_down(0.125.in)
    doc.indent(0.25.in){
      doc.text "If #{ client[:first_name] } #{client[:last_name] } was present for tutoring today:"  , :style=>:bold
      doc.move_down(0.125.in)
#  doc.text "We will be prepared to see #{ client[:first_name] } #{ client[:last_name] } again on #{following_date.datetime.strftime( '%a %b %d at %I:%M %P' ) } in #{following_date.location_code}."  , :style=>:italic
    }
    doc.move_down(0.125.in)
    doc.indent(0.25.in){
      doc.text "If #{ client[:first_name] } #{ client[:last_name] } was not present for tutoring today:" , :style=>:bold
      doc.move_down(0.125.in)
      doc.text "Please call me so that we can save their spot for the next seesion. If not we might be forced to drop him or her from the program."  , :style=>:italic
    }
    doc.move_down(0.125.in)
    doc.text "Studies have shown that the most successful students are those whose parents are actively involved in the educational process. Thank you for your involvement and for this opportunity to help."
    doc.move_down(0.125.in)
    doc.text "Sincerely,"
    doc.move_down(0.125.in)
    doc.text "Eric Laquer, director"
    doc.move_down(0.5.in)

    doc.text "Tutoring Club of Washington Township"
    doc.text "LaquerEric@gmail.com"
    doc.text "856 589 8867 x 1"

  end

  def self.print_education_report_pdf(client)
#filename, school_district, client, education_event_array
    self.education_event_array = EducationEvent.all_for(client)
    if education_event_array.length == 0
      p "No education events were entered for client #{client.client_id}  #{client.last_name}, #{client.first_name}"
      return false
    end
    filename = File.join(
        self.local_directory, "client_#{client.client_id.to_i}__education.pdf"
    )
    p "Education events (#{education_event_array.length}) for client #{client.client_id}  #{client.last_name}, #{client.first_name} were used to create #{filename}"
        #  Document::Reports::Education.print_education_report_pdf(
    #    filename, self, client, education_event_array
    #  )
    #end
 
    lines = []
 
    letter = self
    template = self
    school_district = client.school_district_object
# 
    Prawn::Document.generate( filename ) do |pdf|

    #Prawn::Document.generate(filename) do
      #stroke do
        template.return_address_bounding_box( pdf )

        template.address_bounding_box( pdf ){ |doc|
          doc.text "To the parents or guardians of:"
          doc.text "#{ client[:first_name] } #{ client[:last_name] }"
          doc.text "#{ client[:address_line_1]}"
          doc.text "#{ client[:address_line_2]}"
          doc.text "#{ client[:city]}, #{ client[:state]} #{ client[:zip].to_s.gsub('_',' ') }"
        }

        template.header_bounding_box( pdf ){
          letter.header_for(pdf,school_district,client)
        }

        letter.body_bounding_box( pdf ){
          letter.body_for(pdf,school_district,client)
        }

        letter.table_bounding_box( pdf ){
          Document::Reports::Education.table_for( pdf, education_event_array )
        }

    end

    return lines
  end

end

