require 'prawn'
require "prawn/measurement_extensions"

class Document::Letter::TwoWindowTemplate

#################################
# Layout
#################################

  def self.page()

    { :header_height => 1.0.in , :footer_height => 0.5.in , :content_width => 7.5.in }

  end

  def self.name_block(pdf)

    pdf.font_size = 8
    pdf.text "TUTORING CLUB of Washington Twp"
    pdf.text " "
    pdf.text "279-D Egg Harbor Road"
    pdf.text "Sewell, NJ 08080"
    pdf.text " "
    pdf.text "(856) 589-8867"

  end

  def self.header_bounding_box( doc , &block )

    header_top_left = [ doc.bounds.left + 4.25.in , doc.bounds.top ]
    header_width = 3.25.in
    header_height = 3.in

    doc.bounding_box( header_top_left, :width => header_width, :height => header_height ) {
      doc.stroke_color "cc1133"
      doc.stroke_bounds
      doc.move_down(0.125.in)
      doc.indent(0.125.in){
        yield(doc)
      }
   }
  
  end

  def self.greeting_bounding_box( doc , &block )

    greeting_top_left = [ doc.bounds.left, doc.bounds.top - 3.25.in ]
    greeting_width =  doc.bounds.width
    greeting_height = 0.5.in

    doc.bounding_box( greeting_top_left, :width => greeting_width, :height => greeting_height ) {
      #doc.stroke_bounds
      doc.move_down(0.125.in)
      doc.indent(0.125.in){
        yield(doc)
      }
   }
  
  end

  def self.body_bounding_box( doc , &block )

    body_top_left = [ doc.bounds.left , doc.bounds.top - 3.75.in ]
    body_width = doc.bounds.width
    body_height = 6.25.in

    doc.bounding_box( body_top_left, :width => body_width, :height => body_height ) {
      #doc.stroke_bounds
      doc.move_down(0.125.in)
      doc.indent(0.125.in){
        yield(doc)
      }
   }
  
  end

  def self.return_address_bounding_box( doc , &block )

    logo_width = 2.0.in

    logo_top_left = [ doc.bounds.left , doc.bounds.top - 0.125 ]
    logo_height = self.page[:header_height]

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

  def self.address_bounding_box( doc , &block )

    address_top_left = [ doc.bounds.left - 0.125 , doc.bounds.top - 1.75.in ]

    address_width = 4.in
    address_height = 1.in
    
    doc.bounding_box( address_top_left, :width => address_width, :height => address_height ) {
      doc.font_size = 12
      #doc.stroke_bounds
      doc.move_down(0.25.in)
      doc.indent(0.75.in){
        yield(doc)
      }
    }

  end

  def self.footer_bounding_box( doc , &block )

    footer_top_left = [ doc.bounds.left, doc.bounds.bottom+0.5.in ] 

    doc.font_size = 10
    doc.bounding_box(footer_top_left , :width => self.page[:content_width] , :height => self.page[:footer_height] ) { |idoc|
      doc.stroke_bounds
      yield(doc)
    }

  end

end

