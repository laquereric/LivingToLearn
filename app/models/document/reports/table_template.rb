require 'prawn'
require "prawn/measurement_extensions"

class Document::Reports::TableTemplate

  cattr_accessor :last_page
  cattr_accessor :last_column
  cattr_accessor :last_line

  cattr_accessor :header_lines
  cattr_accessor :columns

  cattr_accessor :pages

#################################
# Layout
#################################

  def self.page()
    { :header_height => 1.0.in , :footer_height => 0.5.in , :content_width => 7.5.in }
  end

  def self.table()

    return {
      :rows => 3,
      :columns => 3
    }

  end

  def self.name_block(pdf)
    pdf.font_size = 8
    pdf.text " "
    pdf.text "TUTORING CLUB of Washington Twp"
    pdf.text "279-D Egg Harbor Road"
    pdf.text "Sewell, NJ 08080"
    pdf.text " "
    pdf.text "(856) 589-8867"
  end

  def self.header_bounding_box( doc , &block )
    name_width = 2.5.in

    logo_width = 2.0.in
    logo_height = self.page[:header_height]

    header_top_left = [ doc.bounds.left , doc.bounds.top ]
    header_top_right = [ doc.bounds.right-name_width , doc.bounds.top ]
    header_content_top_left = [ doc.bounds.left + 2.in , doc.bounds.top ]

    logo = File.join(Rails.root,'public','images','tc_logo.jpg')
    doc.image logo, :at => [ header_top_left[0] + 0.1.in , header_top_left[1] - 0.1.in ], :width => logo_width * 0.9, :height => logo_height * 0.9

    doc.bounding_box( header_top_right , :width => name_width, :height => self.page[:header_height] ) {
      doc.indent(0.25.in){
         self.name_block(doc)
      }
    }

    doc.font_size = 10
    doc.bounding_box( header_content_top_left , :width => self.page[:content_width] - logo_width - name_width , :height => self.page[:header_height] ) {
      doc.stroke_bounds
      doc.font_size = 6
      doc.indent(10) {
         doc.text " "
         yield doc
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

  def self.cell_bounding_box_for( doc , row , column , &block )

    overall_content_height = doc.bounds.top - doc.bounds.bottom
    cells_content_height = overall_content_height - self.page[:header_height] - self.page[:footer_height] - ( ( self.table[:rows] + 1 ) * 0.125.in )
    cell_content_height = cells_content_height / self.table[:rows]
    y_offset = doc.bounds.top - self.page[:header_height] - ( row * ( cell_content_height + 0.125.in ) ) - 0.125.in

    overall_content_width = doc.bounds.right - doc.bounds.left
    cells_content_width = overall_content_width - ( ( self.table[:columns] - 1 ) * 0.125.in )
    cell_content_width = cells_content_width / self.table[:columns]
    x_border_offset = if column == 0 then 0 else column * 0.125.in end
    x_offset = doc.bounds.left + x_border_offset + ( column * cell_content_width )

    doc.font_size = 6
    doc.bounding_box([x_offset,y_offset], :width => cell_content_width, :height => cell_content_height ) do
      doc.stroke_bounds
      doc.indent(5) {
         doc.text " "
         yield doc
      }
    end

  end

#################################
# Data
#################################

  def self.current_page_has_content?
    r = (!self.header_lines.nil? and !self.columns.nil?)
    return r
  end

  def self.get_current_page_data(page_index = nil)
    r= {} 
    if page_index.nil? then
      r[:header_lines] = self.header_lines.dup if self.header_lines
      r[:columns] = self.columns.dup if self.columns
      self.reset_current_page_data
    else
      r[:header_lines] = self.header_lines.dup if self.header_lines
      r[:columns] = self.pages[page_index]
    end
    return r
  end

  def self.reset_current_page_data
    self.header_lines = nil
    self.columns = nil
  end

  def self.print_cell(pdf,client)
p "to pdf #{client.client_id.to_i}"
    pdf.font_size = 10
    pdf.text client.client_line(6)
    pdf.font_size = 12
    pdf.text "      ATTENDED?   [   ]"
    pdf.font_size = 6
    client_data(client){ |line|
      pdf.text line[1]
    }
  end
#########################
# Saving Data for later Printing
#########################

  def self.save_cell( column_number , row_number , hash )

    self.columns ||= []
    self.columns[column_number] ||= []
    self.columns[column_number]<< hash

  end

  def self.save_page_cell( page_number , column_number , row_number , hash )

    if self.pages.nil?
      self.pages = []
    end

    if page_number+1 > self.pages.length
      self.pages[page_number] = []
      self.columns = self.pages[page_number]
    end

    if  self.columns[column_number].nil?
      self.columns[column_number] = []
    end

    self.columns[column_number]<< hash

  end

  def self.save_header( doc, page_number, header_0, header_1, school_district, school, result, mode= :do )

    self.header_lines = [ header_0, header_1, school_district, school, result]

  end

#####################################
# Send Data to Page
######################################

  def self.move_saved_to_page(pdf,page_data,new_page=true,&block)

    pdf.start_new_page if new_page
    pdf.stroke do
        if page_data[:header_lines]
          self.header_bounding_box(pdf){
            if block_given?
              yield([:header_lines , page_data[:header_lines] , pdf])
            else
              page_data[:header_lines].each{ |header_line|
                pdf.text header_line
              }
            end
          }
        end
        Document::Reports::BySchool.footer_bounding_box(pdf){
          page_data[:header_lines].each{ |header_line|
            pdf.text header_line
          } if page_data[:footer_lines]
        }

        (0..self.table[:columns]-1).each{ |column|
          next if page_data.nil?
          next if page_data[:columns].nil?
          next if page_data[:columns][column].nil?
          column_data = page_data[:columns][column]
          (0..self.table[:rows]-1).each{ |row|
            row_data = column_data[row] if column_data
            self.cell_bounding_box_for(pdf,row,column){
              self.print_cell(pdf,row_data)  if row_data
            }
          }
        }

    end
  end

end

