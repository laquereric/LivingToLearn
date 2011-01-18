class Document::Letter::SesAppointment <  Document::Letter::TwoWindowTemplate

#############
# Directory
#############

  def self.local_directory

    File.join( ENV['ARCHIVED_COMMUNICATIONS_DIR'] , "appointment_letters" )

  end

  def self.filename_for(client)

    Dir.mkdir(self.local_directory) if !File.exists?(self.local_directory)
    fn = "#{client.client_id.to_i}__#{client.last_name}_#{client.first_name}__SD_#{client.school_district_object.code_name}.pdf"
    File.join( self.local_directory, fn )

  end

  def self.print_for(client,filename,reference = DateTime.now)

    letter = self
    template = self
    dates = client.next_appointment_dates
    school_district = client.school_district_object
#p school_district
#p "dates: #{dates.inspect}"

    ok = if dates.length == 0

      p "  #{ client[:client_id].to_i } #{ client[:last_name] } #{ client[:first_name] } has no scheduled tutoring sessions!"
      false

    else

      true

    end
    next_date = dates.select{ |d| d.relative_tag == :next }[0]
    following_date = dates.select{ |d| d.relative_tag == :following }[0]

    return ok if !ok

    Prawn::Document.generate( filename ) do |pdf|

      template.return_address_bounding_box( pdf )

      template.address_bounding_box( pdf ){ |doc|
        doc.text "To the parents or guardians of:"
        doc.text "#{ client[:first_name] } #{ client[:last_name] }"
        doc.text "#{ client[:address_line_1]}"
        doc.text "#{ client[:address_line_2]}"
        doc.text "#{ client[:city]}, #{ client[:state]} #{ client[:zip].to_s.gsub('_',' ') }"
      }

      template.header_bounding_box( pdf ){ |doc|
        letter.header_for(doc,school_district,client,next_date,following_date)
      }

      template.body_bounding_box( pdf ){ |doc|
        letter.body_for(doc,school_district,client,next_date,following_date)
      }

    end

    return true

  end

def self.header_for(doc,school_district,client,next_date,following_date)

  doc.fill_color "0055DD"
  doc.font_size = 12
  doc.text "RECORD OF ATTENDANCE"
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
end

def self.body_for(doc,school_district,client,next_date,following_date)
  doc.font_size = 12
  doc.fill_color "000000"
doc.text "As part of the #{school_district.pretty_name} Supplemental Education Services (SES) program, your student is enrolled to receive tutoring from the Tutoring Club."
doc.move_down(0.125.in)
doc.text "This note is your record of his or her attendance. The box at the top of this page indicates whether they were present for this scheduled session."
doc.move_down(0.125.in)
doc.indent(0.25.in){
  doc.text "If #{ client[:first_name] } #{client[:last_name] } was present for tutoring today:"  , :style=>:bold
  doc.move_down(0.125.in)
  doc.text "We will be prepared to see #{ client[:first_name] } #{ client[:last_name] } again on #{following_date.datetime.strftime( '%a %b %d at %I:%M %P' ) } in #{following_date.location_code}."  , :style=>:italic
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

end
