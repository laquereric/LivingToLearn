class Document::Letter::RecordsOnlyTutor <  Document::Letter::TwoWindowTemplate

  def self.name_block(pdf)

    pdf.font_size = 8
    pdf.text "Tutoring Club"
    pdf.text "279 Egg Harbor Rd"
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

    logo = File.join( RAILS_ROOT, 'public' , 'images' , 'tc_logo.jpg' )
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

    File.join( ENV['ARCHIVED_COMMUNICATIONS_DIR'] , "records_only_tutor_letters" )

  end

  def self.filename_for(tutor)

    Dir.mkdir(self.local_directory) if !File.exists?(self.local_directory)
    fn = "#{tutor.mnemonic}.pdf"
    File.join( self.local_directory, fn )

  end

  def self.print_for(tutor)

    letter = self
    template = self
    filename = self.filename_for(tutor)

p "Creating PDF letter #{filename} for #{tutor}"

    Prawn::Document.generate( filename ) do |pdf|

      template.return_address_bounding_box( pdf )

      template.address_bounding_box( pdf ){ |doc|
        doc.text "#{ tutor[:first_name] } #{ tutor[:last_name] }"
        doc.text "#{ tutor[:address_line_1]}"
        doc.text "#{ tutor[:address_line_2]}"
        zip = sprintf( '%05d',tutor[:zip].to_i )
        doc.text "#{ tutor[:city]}, #{ tutor[:state]} #{zip}"
      }

      template.header_bounding_box( pdf ){ |doc|
        letter.header_for(doc,tutor)
      }

      template.body_bounding_box( pdf ){ |doc|
        letter.body_for(doc,tutor)
      }

    end

    return true

  end

def self.header_for(doc,tutor)

end

def self.body_for(doc,tutor)
  doc.font_size = 10
  doc.fill_color "000000"
  doc.text <<-eos
Dear  #{tutor.first_name} #{tutor.last_name}

Thank you for becoming a records-only tutor.

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
