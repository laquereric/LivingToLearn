class Document::Letter::WoodburyContract <  Document::Letter::TwoWindowTemplate

  def self.print_for(client,filename)
    letter = self
    template = self
    Prawn::Document.generate("letter.pdf") do |pdf|
      template.return_address_bounding_box( pdf )
      template.address_bounding_box( pdf ){ |doc|
        doc.text "To the parents of:"
        doc.text "#{ client[:first_name] } #{ client[:last_name] }"
        doc.text "#{ client[:address_line_1]}"
        doc.text "#{ client[:address_line_2]}"
        doc.text "#{ client[:city]} , #{ client[:state]} #{ client[:zip] }"
      }
      template.header_bounding_box( pdf ){ |doc|
        letter.header_for(doc,client)
      }
      template.greeting_bounding_box( pdf ){ |doc|
        letter.greeting_for(doc,client)
      }
      template.body_bounding_box( pdf ){ |doc|
        letter.body_for(doc,client)
      }
    end
    return

  end

def self.header_for(doc,client)
  doc.fill_color "0055DD"
  doc.font_size = 14
  doc.text "#{client[:first_name]} #{client[:last_name]}"
  doc.text "is now enrolled in the"
  doc.text "Woodbury City Public Schools"
  doc.text "Supplemental Education Program"
  doc.text " "
  doc.font_size = 14
  doc.text "Sessions are held"
  doc.text "Mondays and Wednesdays"
  doc.text "After School at Woodbury High"
  doc.text " "
  doc.font_size = 14
  doc.text "Call Eric at 856 589 8867"
  doc.text "For more information"
end

def self.greeting_for(doc,client)
  doc.font_size = 12
  doc.fill_color "000000"
  doc.text "Dear Parent or Guardian of #{client[:first_name]} #{client[:last_name]}"
end

def self.body_for(doc,client)
  doc.font_size = 10
  doc.fill_color "000000"
  doc.text <<-eos
Thank you for enrolling your student in the Woodbury Public Schools Supplemental Education Services  (SES) program! Tutoring Club will be providing the tutoring so I am writing to you today to introduce myself. My name is Eric Laquer and I am the Director of the program.

Tutoring Club was formed over 20 years ago to help student reach their potential using tools and techniques that at that time were revolutionary. Now the company has more than 100 locations internationally. Surprisingly, our approach is still very advanced compared to most.

We base our system on two things:
Getting the right materials to the student at exactly the right time.
Providing a qualified tutor for every 3 students.

Our core programs cover Math, Reading and Writing from Kindergarten thru 12th grade. Your SES benefits can be used ONLY for the core subjects. That said, we are offering you FREE OF CHARGE additional instructional time and material that orients the program to serve specific needs of 8th grade ASK and 11th Grade HSPA test takers. We also have material to serve students taking the SAT or ACT.

Please review the enclosed schedule then give me a call to let me know when and where we can tutor your student. The Woodbury SES benefit covers 24 hours (or 16 90-minute sessions). That's enough to make a real and lasting difference in your students future, whatever their plan might be.

Thanks for this opportunity to help!

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
