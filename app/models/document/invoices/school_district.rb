require 'prawn'
require "prawn/measurement_extensions"

class Document::Invoices::SchoolDistrict

  def self.create_from_to( invoice , filename )
    Prawn::Document.generate(filename) do
      stroke do
        line(bounds.bottom_left, bounds.bottom_right)
        line(bounds.bottom_right, bounds.top_right)
        line(bounds.top_right, bounds.top_left)
        line(bounds.top_left, bounds.bottom_left)
      end

      logo = File.join(Rails.root,'public','images','tc_logo.jpg')
      image logo, :at => [0.5.in,bounds.top-0.1.in], :width=> 3.in, :height => 1.3.in

      bounding_box([bounds.left+3.75.in,bounds.top-0.in], :width => 3.75.in, :height => 1.5.in) do
        stroke_bounds
        indent(0.25.in){
          text " "
          text "TUTORING CLUB of Washington Twp"
          text "279-D Egg Harbor Road"
          text "Sewell, NJ 08080"
          text " "
          text "(856) 589-8867"
        }
      end
 
      bounding_box([bounds.left+0.in,bounds.top-1.5.in], :width => 7.5.in, :height => 0.5.in) do
        stroke_bounds
        indent(2.5.in){
          text " "
          text "Monthly SES Tuition Invoice"
        }
      end

      bounding_box([bounds.left+0.in,bounds.top-2.in], :width => 7.5.in, :height => 1.5.in) do
        stroke_bounds
        indent(2.5.in){
          text " "
          text " "
          text "#{ invoice[:student_first_name] } #{ invoice[:student_last_name] }"
          text "#{ invoice[:district_name] }"
          text "#{ invoice[:district_city] }, #{ invoice[:district_state] }  #{ invoice[:district_zip] }"
        }
      end

      bounding_box([bounds.left+0.in,bounds.top-3.5.in], :width => 3.75.in, :height => 0.5.in) do
        stroke_bounds
        indent(0.25.in){
          text " "
          text "Invoice Number : #{ invoice[:invoice_number] }"
        }
      end

      bounding_box([bounds.left+3.75.in,bounds.top-3.5.in], :width => 3.75.in, :height => 0.5.in) do
        stroke_bounds
        indent(0.25.in){
          text " "
          text "Invoice Date : #{ invoice[:invoice_date].strftime( '%b %d , %Y' ) }"
        }
      end

      bounding_box([bounds.left+0.in,bounds.top-4.in], :width => 3.75.in, :height => 1.in) do
        stroke_bounds
        indent(0.25.in){
          text " "
          text "School : #{ invoice[:school] }"
          text "Per Pupil Amount : $#{ sprintf( '%2.2f', invoice[:per_pupil_amount]) } "
        }
      end

      bounding_box([bounds.left+3.75.in,bounds.top-4.in], :width => 3.75.in, :height => 1.in) do
        stroke_bounds
        indent(0.25.in){
          text " "
          text "Period Start : #{ invoice[:period_start].strftime( '%b %d , %Y' ) }"
          text "Period End : #{ invoice[:period_end].strftime( '%b %d , %Y' ) }"
        }
      end

      bounding_box([bounds.left+0.0.in,bounds.top-5.in], :width => 7.5.in, :height => 4.in) do
        stroke_bounds
        indent(2.in){
          text " "
          text "Testing Fee : #{ sprintf( '%2.2f', invoice[:testing_fee]) }"
          text "Registration Fee : #{ sprintf( '%2.2f', invoice[:registration_fee]) }"
          text " "
          if invoice[:second_invoice_line]
            text "Contract Line #{invoice[:fc_name].titleize}"
          end
          text "Hours : #{sprintf( '%2.1f', invoice[:fc_hours])}"
          text "Hourly Rate : #{ sprintf( '%2.2f', invoice[:fc_rate] ) }"
          text "Line Amount : #{ sprintf( '%2.2f', invoice[:fc_amount] ) }"
          text " "
          if invoice[:second_invoice_line]
            text "2nd Contract Line #{ invoice[:sc_name].titleize }"
            text "2nd Hours : #{ sprintf( '%2.1f', invoice[:sc_hours]) }"
            text "2nd Hourly Rate : #{ sprintf( '%2.2f', invoice[:sc_rate]) }"
            text "2nd Line Amount : #{ sprintf( '%2.2f', invoice[:sc_amount]) }"
            text " "
          end
          text "Total Amount Due : #{ sprintf('%2.2f', invoice[:total_amount]) }"
        }
      end

      bounding_box([bounds.left+0.in,bounds.top-9.in], :width => 7.5.in, :height => 1.in) do
        stroke_bounds
        indent(0.25.in){
          text " "
          text "Signed and Dated by #{ invoice[:director_name] } , Director"
        }
      end
    end
  end
end
