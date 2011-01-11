require 'prawn'
require "prawn/measurement_extensions"

class Document::Reports::Education

  def self.print_education_report_pdf(
    filename, school_district, client,education_event_array
    )
    lines = []

    Prawn::Document.generate(filename) do
      stroke do

        line(bounds.bottom_left, bounds.bottom_right)
        line(bounds.bottom_right, bounds.top_right)
        line(bounds.top_right, bounds.top_left)
        line(bounds.top_left, bounds.bottom_left)

        text "#{client.client_id.to_i.to_s} #{client.first_name} #{client.last_name}"
        education_event_array.map{ |ee|
          ee[:order] ||= 0
          ee
        }.sort{ |x,y|
          x[:order] <=> y[:order]
        }.each{ |education_event|
          dt = education_event[:date]
          text "#{dt} #{education_event[:event].to_s} #{education_event[:result].to_s}"
        }

      end
    end

    return lines
  end

end

