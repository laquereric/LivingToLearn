require 'prawn'
require "prawn/measurement_extensions"

class Document::Reports::Education <  Document::Reports::TableTemplate

  def self.table_for(pdf,education_event_array)

        #text "#{client.client_id.to_i.to_s} #{client.first_name} #{client.last_name}"
        pdf.font_size 4
        education_event_array.map{ |ee|
          ee[:order] ||= 0
          ee
        }.sort{ |x,y|
          x[:order] <=> y[:order]
        }.each{ |education_event|
          dt = education_event[:date]
          pdf.text "#{dt} #{education_event[:event].to_s} #{education_event[:result].to_s}"
        }
  end

end

