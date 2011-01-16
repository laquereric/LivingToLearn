class Document::Letter::WoodburyAppointment <  Document::Letter::TwoWindowTemplate

  def self.print_for(appointment,filename)
    letter = self
    template = self
    Prawn::Document.generate("letter.pdf") do |pdf|
      template.return_address_bounding_box( pdf )
      template.address_bounding_box( pdf ){ |doc|
        doc.text "To the parents of:"
        doc.text "#{ appointment.client[:first_name] } #{ appointment.client[:last_name] }"
        doc.text "#{ appointment.client[:address_line_1]}"
        doc.text "#{ appointment.client[:address_line_2]}"
        doc.text "#{ appointment.client[:city]} , #{ appointment.client[:state]} #{ appointment.client[:zip] }"
      }
      template.header_bounding_box( pdf ){ |doc|
        letter.header_for(doc,appointment)
      }
      template.greeting_bounding_box( pdf ){ |doc|
        letter.greeting_for(doc,appointment)
      }
      template.body_bounding_box( pdf ){ |doc|
        letter.body_for(doc,appointment)
      }
    end
    return

  end

def self.header_for(doc,appointment)
  doc.fill_color "0055DD"
  doc.font_size = 12
  doc.text "Personalized educational materials "
  doc.text "and a tutor were available for"
  doc.text "#{appointment.client[:first_name]} #{appointment.client[:last_name]}"
  doc.text "on #{appointment.this_time}"
  doc.text "at #{appointment.this_location}"
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

def self.greeting_for(doc,appointment)
  doc.font_size = 12
  doc.fill_color "000000"
  doc.text "Dear Parent or Guardian of #{appointment.client[:first_name]} #{appointment.client[:last_name]}"
end

def self.body_for(doc,appointment)
  doc.font_size = 10
  doc.fill_color "000000"
  doc.text <<-eos
Thank you for enrolling your student in the Woodbury Public Schools Supplemental Education Services  (SES) program! Tutoring Club will be providing the tutoring so I am writing to you today to introduce myself. My name is Eric Laquer and I am the Director of the program.

If #{ appointment.client[:first_name] } #{ appointment.client[:last_name] } did receive the service:

We will be prepared to see #{ appointment.client[:first_name] } #{ appointment.client[:last_name] } again on #{appointment.next_time} at #{appointment.next_location}."

If #{ appointment.client[:first_name] } #{ appointment.client[:last_name] } did not receive the service:

Please call me!

We will be prepared to see #{ appointment.client[:first_name] } #{ appointment.client[:last_name] } on #{appointment.next_time} at #{appointment.next_location} if you can call to confirm."

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
