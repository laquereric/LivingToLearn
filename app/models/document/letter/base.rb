class Document::Letter::Base <  Document::Letter::TwoWindowTemplate

  def self.print(letter)

    Prawn::Document.generate("letter.pdf") do |pdf|
      self.return_address_bounding_box( pdf ){ |doc|
        doc.text "Header Stuff"
      }
      self.address_bounding_box( pdf ){ |doc|
        doc.text "To the parents of: #{ letter[:first_name] } #{ letter[:last_name] }"
        doc.text "#{ letter[:address_line_1]}"
        doc.text "#{ letter[:address_line_2]}"
        doc.text "#{ letter[:city]} , #{ letter[:state]} #{ letter[:zip] }"
      }
      self.header_bounding_box( pdf ){ |doc|
        doc.text "Hello World!!"
      }
    end
    return

  end

end
