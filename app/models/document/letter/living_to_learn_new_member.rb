class Document::Letter::LivingToLearnNewMember <  Document::Letter::TwoWindowTemplate

#############
# Directory
#############

  def self.local_directory

    File.join( ENV['ARCHIVED_COMMUNICATIONS_DIR'] , "living_to_learn_new_member_letters" )

  end

  def self.filename_for(member)

    Dir.mkdir(self.local_directory) if !File.exists?(self.local_directory)
    fn = "#{member.business_name}.pdf"
    File.join( self.local_directory, fn )

  end

  def self.print_for(member)

    letter = self
    template = self
    filename = self.filename_for(member)

    Prawn::Document.generate( filename ) do |pdf|

      template.return_address_bounding_box( pdf )

      template.address_bounding_box( pdf ){ |doc|
        doc.text "#{ member[:contact_first_name] } #{ member[:contact_last_name] }"
        doc.text "#{ member[:contact_address_line_1]}"
        doc.text "#{ member[:contact_address_line_2]}"
        doc.text "#{ member[:contact_city]}, #{ member[:contact_state]} #{ member[:contact_zip].to_s.gsub('_',' ') }"
      }

      template.header_bounding_box( pdf ){ |doc|
        letter.header_for(doc,member)
      }

      template.body_bounding_box( pdf ){ |doc|
        letter.body_for(doc,member)
      }

    end

    return true

  end

def self.header_for(doc,member)

  doc.fill_color "0055DD"
  doc.font_size = 12
  doc.text "Acknowledgement of Registration"
  doc.move_down(0.5.in)
  doc.text "Your registration as a Member of"
  doc.text "Living To Learn was accepted"

end

def self.body_for(doc,member)
  doc.font_size = 12
  doc.text <<-eos
Dear  #{member.contact_first_name} #{member.contact_last_name}

Thank you for the opportunity to present the the advantages of membership in “Living to Learn” to you. We would like “Living to Learn” to become an important part in the growth and health of our communities and are encouraged by your support.

It is our sincere hope that you will be completely satisfied with the services that “Living to Learn” will provide for you, your employees and their family members.

We are always interested in suggestions that would allow us to improve our business and we encourage you to submit any thoughts or questions you might have.

Thank you again,


Eric Laquer, CEO
Living To Learn
283-B Egg Harbor Rd. #122
Sewell, NJ 08080-3156

LaquerEric@gmail.com
856 270 6810
eos

end

end
