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

  def self.print_for(client,filename,reference=DateTime.now)

    letter = self
    template = self
    dates = client.next_appointment_dates
    school_district = client.school_district_object
#p school_district
#p "dates: #{dates.inspect}"

    ok = if dates[:next].nil?

      p "  #{ client[:client_id].to_i } #{ client[:last_name] } #{ client[:first_name] } has no scheduled tutoring sessions!"
      false

    else

      true

    end

    return ok if !ok

    Prawn::Document.generate( filename ) do |pdf|

      template.return_address_bounding_box( pdf )

      template.address_bounding_box( pdf ){ |doc|
        doc.text "To the parents of:"
        doc.text "#{ client[:first_name] } #{ client[:last_name] }"
        doc.text "#{ client[:address_line_1]}"
        doc.text "#{ client[:address_line_2]}"
        doc.text "#{ client[:city]} , #{ client[:state]} #{ client[:zip] }"
      }

      template.header_bounding_box( pdf ){ |doc|
        letter.header_for(doc,school_district,client,dates)
      }

      template.greeting_bounding_box( pdf ){ |doc|
        letter.greeting_for(doc,school_district,client,dates)
      }

      template.body_bounding_box( pdf ){ |doc|
        letter.body_for(doc,school_district,client,dates)
      }

    end

    return true

  end

def self.header_for(doc,school_district,client,dates)

  doc.fill_color "0055DD"
  doc.font_size = 12
  doc.text "Personalized educational materials "
  doc.text "and a tutor were available for"
  doc.text "#{client[:first_name]} #{client[:last_name]}"
  doc.text "on #{dates[:next].strftime( '%b %d , %Y' ) }"
  #doc.text "at #{appointment.this_location}"
  doc.text " "
  doc.text "They did receive tutoring help"
  doc.text "       [     ]"
  doc.text " "
  doc.text "They did not receive tutoring help"
  doc.text "       [     ]"
  doc.text " "
  doc.text "Call Eric at 856 589 8867"
  doc.text "For more information"

end

def self.greeting_for(doc,school_district,client,dates)
  doc.font_size = 12
  doc.fill_color "000000"
  doc.text "Dear Parent or Guardian of #{client[:first_name]} #{client[:last_name]}"
end
#" #at # {appointment.next_location}.
#at # {appointment.next_location} 
def self.body_for(doc,school_district,client,dates)
  doc.font_size = 10
  doc.fill_color "000000"
  doc.text <<-eos
Thank you for enrolling your student in the Woodbury Public Schools Supplemental Education Services  (SES) program! Tutoring Club will be providing the tutoring so I am writing to you today to introduce myself. My name is Eric Laquer and I am the Director of the program.

If #{ client[:first_name] } #{client[:last_name] } did receive the service:

We will be prepared to see #{ client[:first_name] } #{ client[:last_name] } again on #{dates[:next].strftime( '%b %d , %Y' ) } "
If #{ client[:first_name] } #{ client[:last_name] } did not receive the service:

Please call me!

We will be prepared to see #{ client[:first_name] } #{ client[:last_name] } on #{dates[:next].strftime( '%b %d , %Y' ) } if you can call to confirm."

Thanks for your involvement!"

Thanks you for this opportunity to help!

Sincerely



Eric Laquer

Director of the Tutoring Club of Washington Township
New Market Place 279 D Egg Harbor Rd.
Sewell, NJ 08080
Email: LaquerEric@gmail.com
Cell: 856 589 8867 Ext 1
eos
end

end
