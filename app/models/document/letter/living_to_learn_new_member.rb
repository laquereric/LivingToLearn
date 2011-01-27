class Document::Letter::LivingToLearnNewMember <  Document::Letter::TwoWindowTemplate

  def self.name_block(pdf)

    pdf.font_size = 8
    pdf.text "Living To Learn"
    pdf.text "283-B Egg Harbor Rd. #122"
    pdf.text "Sewell, NJ 08080-3156"

  end

  def self.return_address_bounding_box( doc , &block )

    logo_width = 1.5.in

    logo_top_left = [ doc.bounds.left , doc.bounds.top - 0.125 ]
    #logo_height = self.page[:header_height]-0.5.in
    logo_height = 1.in

    return_address_top_left = [ doc.bounds.left + logo_width - 0.25.in , doc.bounds.top ]

    return_address_width = 3.5.in-logo_width
    return_address_height = 1.25.in

    logo = File.join( RAILS_ROOT, 'public' , 'images' , 'livingtolearn.jpg' )
    doc.image logo, :at => logo_top_left , :width => logo_width * 0.9, :height => logo_height * 0.9

    doc.bounding_box( return_address_top_left , :width => return_address_width , :height => return_address_height ) {
      #doc.stroke_bounds
      doc.move_down( 0.125.in )
      doc.indent( 0.125.in ){
        self.name_block( doc )
      }
    }

  end

#############
# Directory
#############

  def self.local_directory

    File.join( ENV['ARCHIVED_COMMUNICATIONS_DIR'] , "living_to_learn_new_member_letters" )

  end

  def self.filename_for(member)

    Dir.mkdir(self.local_directory) if !File.exists?(self.local_directory)
    fn = "#{member.organization_name}.pdf"
    File.join( self.local_directory, fn )

  end

  def self.print_for(member)

    letter = self
    template = self
    filename = self.filename_for(member)

p "Creating PDF letter #{filename} for #{member}"

    Prawn::Document.generate( filename ) do |pdf|

      template.return_address_bounding_box( pdf )

      template.address_bounding_box( pdf ){ |doc|
        doc.text "#{ member[:contact_first_name] } #{ member[:contact_last_name] }"
        doc.text "#{ member[:organization_name] }"
        doc.text "#{ member[:contact_address_line_1]}"
        doc.text "#{ member[:contact_address_line_2]}"
        zip = sprintf( '%05d',member[:contact_zip].to_i )
        doc.text "#{ member[:contact_city]}, #{ member[:contact_state]} #{zip}"
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

  return if member.organization_type.nil? or member.organization_type.length == 0
  doc.bounding_box( [ doc.bounds.top_left[0]+0.125.in , doc.bounds.top_left[1]-0.125.in  ],
  :width => doc.bounds.width-0.25.in, :height => doc.bounds.height-0.25.in ) {
    doc.fill_color "0055DD"
    doc.font_size = 10
    doc.text "Your registration as a #{member.organization_type.titleize} member Living To Learn was accepted. Please consider:",:style=>:bold

    obfs = member.get_objectives_benefits_features
    return if obfs.nil?
    obfs.each{ |obf|
      self.obf_feature(doc,obf)
    }
  }

end

def self.obf_feature(doc,obf)

  doc.indent(0.125.in){
    doc.move_down(0.125.in)
    doc.text obf.feature
  }

end

def self.obf(doc,obf,index)

  doc.fill_color "0055DD"
  obf_height = 1.125.in
  obf_top = doc.bounds.top - 3.75.in - ( index * obf_height )

  section_width = 2.in

  objective_left = doc.bounds.left + ( (section_width+0.125) * 0 )
  benefit_left = doc.bounds.left + ( (section_width+0.125) * 1 )
  feature_left = doc.bounds.left + ( (section_width+0.125) * 2 )

  doc.bounding_box( [ objective_left , obf_top ],
    :width => section_width-0.125.in, :height => obf_height-0.125.in ) {
    doc.stroke_bounds
    doc.bounding_box( [ doc.bounds.top_left[0]+0.125.in , doc.bounds.top_left[1]-0.125.in  ],
      :width => doc.bounds.width-0.25.in, :height => obf_height-0.25.in ) {
      doc.font_size = 8
      doc.text 'Objective',:style=>:bold
      doc.indent(0.125.in){
       doc.font_size = 5
        doc.text obf.objective
      }
    }
  }

  doc.bounding_box( [ benefit_left , obf_top ],
    :width => section_width-0.125.in, :height => obf_height-0.125.in ) {
    doc.stroke_bounds
    doc.bounding_box( [ doc.bounds.top_left[0]+0.125.in , doc.bounds.top_left[1]-0.125.in  ],
      :width =>  doc.bounds.width-0.25.in, :height => obf_height-0.25.in ) {
      doc.font_size = 8
      doc.text 'Benefit',:style=>:bold
      doc.indent(0.125.in){
        doc.font_size = 6
        doc.text obf.benefit
      }
    }
  }

  doc.bounding_box( [ feature_left , obf_top ],
    :width => section_width-0.125.in, :height => obf_height-0.125.in ) {
    doc.stroke_bounds
    doc.bounding_box( [ doc.bounds.top_left[0]+0.125.in , doc.bounds.top_left[1]-0.125.in  ], 
      :width => doc.bounds.width-0.25.in, :height => obf_height-0.25.in ) {
      doc.font_size = 8
      doc.text 'Feature',:style=>:bold
      doc.indent(0.125.in){
        doc.font_size = 6
        doc.text obf.feature
      }
    }
  }

end

def self.obfs_for(doc,member)
  obfs = member.get_objectives_benefits_features
  return if obfs.nil?
  index = 0
  obfs.each{ |obf|
    self.obf(doc,obf,index)
    index += 1
  }
end

def self.body_for(doc,member)
  doc.font_size = 10
  doc.fill_color "000000"
  doc.text <<-eos
Dear  #{member.contact_first_name} #{member.contact_last_name}

Thank you for the opportunity to present the the advantages of membership in “Living to Learn” to you. We would like “Living to Learn” to become an important part in the growth and health of our communities and are encouraged by your support.

It is our sincere hope that you will be completely satisfied with the services that “Living to Learn” will provide for you, your family, your employees, their family members, and even your customers and their families.
eos
 #{member.contact_first_name}
 doc.text <<-eos

We are always interested in suggestions that would allow us to improve our organization and we encourage you to submit any thoughts or questions you might have.

Thank you again,

Eric Laquer, CEO
Living To Learn
283-B Egg Harbor Rd. #122
Sewell, NJ 08080-3156

LaquerEric@gmail.com
856 270 6810
eos

  self.obfs_for(doc,member)

end

end
