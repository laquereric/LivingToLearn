require 'prawn'
require "prawn/measurement_extensions"

class Communication::Ses::WoodburyContract < Communication::Communication
  def self.create_from_to( invoice , filename )
    Prawn::Document.generate('filename') do
      stroke do
        line(bounds.bottom_left, bounds.bottom_right)
        line(bounds.bottom_right, bounds.top_right)
        line(bounds.top_right, bounds.top_left)
        line(bounds.top_left, bounds.bottom_left)
      end
    end
  end

  def columns
    ["first_name","last_name","address_line_1", "address_line_2", "city", "state", "zip"]
  end

  def address_block(client)
  end

  def body(client)
<<-eos
Dear Parent or Guardian of <first_name> <last_name>;

Thank you for enrolling your student in the Woodbury Public Schools Supplemental Education Services  (SES) program! Tutoring Club will be providing the tutoring so I am writing to you today to introduce myself. My name is Eric Laquer and I am the Director of the program.

Tutoring Club was formed over 20 years ago to help student reach their potential using tools and techniques that at that time were revolutionary. Now the company has more than 100 locations internationally. Surprisingly, our approach is still very advanced compared to most.

We base our system on two things:
Getting the right materials to the student at exactly the right time.
Providing a qualified tutor for every 3 student.

Our core programs cover Math, Reading and Writing from Kindergarten thru 12th grade. Your SES benefits can be used ONLY for the core subjects. That said, we are offering you FREE OF CHARGE additional instructional time and material that orients the program to serve specific needs of 8th grade ASK and 11th Grade HSPA test takers. We also have material to serve students taking the SAT or ACT.

Please review the enclosed schedule then give me a call to let me know when and where we can tutor your student. The Woodbury SES benefit covers 24 hours (or 16 90-minute sessions). That s enough to make a real and lasting difference in your students future, whatever their plan might be.

Thanks for this opportunity to help!

Sincerely


Eric Laquer

Director of the Tutoring Club of Washington Township
New Market Place 279 D Egg Harbor Rd.
Sewell, NJ 08080
Email: LaquerEric@gmail.com
Cell: 215 527 1106
 eos

  end

  def get_dataset
    school_district= Government::SchoolDistrict.find_by_government_district_code(5860)
    clients = Person::Client.all_for(school_district)
    contracted_clients = clients.select{ |client| !client.result.nil? and client.result == 'contract' }
    File.open('data.csv','w+'){ |f|
      header= columns.each.map{ |column| column.to_s }.join(',')
      f.puts header
      #f.write "\r\n"
      contracted_clients.each{ |contract_client|
        f.puts columns.each.map{ |column| contract_client.send(column) }.join(',')
        #f.write "\r\n"
      }
    }
  end

end
