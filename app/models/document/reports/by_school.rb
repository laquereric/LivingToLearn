require 'prawn'
require "prawn/measurement_extensions"

class Document::Reports::BySchool

  cattr_accessor :last_page
  cattr_accessor :last_column
  cattr_accessor :last_line

  cattr_accessor :header_lines
  cattr_accessor :columns

  def self.print_page(doc)
    doc.start_new_page if self.last_page > 0
    self.header_lines.each_index{ |index|
      line = header_lines[index]
      doc.text line
    }
    self.columns.each_index{ |index|
      column_lines = columns[index]
      #doc.bounding_box [0,0], :width => 100 do #|box|
        column_lines.each_index{ |line_index|
          line = column_lines[line_index]
          #box.
          #doc.move_to( 100*index, 0 )
          #doc.text line #, :at => [100*index,line_index*2]
          doc.draw_text line , :at => [200*index,650-(line_index*8)]
        }
      #end
    }
    self.last_page += 1
  end

  def self.print_line( doc, page_number , column_number , line_number , text_line, mode= :do )
    if mode == :dump
      doc.text "page_number #{page_number} column_number #{column_number} line_number #{line_number} text: #{text_line}"
    else
      self.columns ||= []
      self.columns[column_number] ||= []
    end
#doc.text text_line
    self.columns[column_number]<< text_line
  end

  def self.print_header( doc, page_number, header_0, header_1, school_district, school, result, mode= :do )

    if mode == :dump
      self.print_line( doc, page_number , -1 , 0 , header_0 )
      self.print_line( doc, page_number , -1 , 1 , header_1 )

      self.print_line( doc, page_number , -1 , 2 , school_district )
      self.print_line( doc, page_number , -1 , 3 , school )
      self.print_line( doc, page_number , -1 , 4 , result )
    else
      if self.columns
        self.print_page(doc)
        self.columns = nil
      end
      self.header_lines = [ header_0, header_1, school_district, school, result]
    end

  end

  def self.print_by_school_report( code_name, local_directory , filename , client_array , month , year, mode= :do )
    client_hash = Person::Client.by_school_hash( client_array )
    line_arrays = []
    status_lines = []
    status= "Stored Report to #{local_directory}"
    #line_arrays << status
    status_lines << status

    self.last_page = 0
    self.last_column = 0
    self.last_line = 0

    page_number = 0
    column_number = 0
    line_number = 0

    result= nil
    Prawn::Document.generate("#{filename}.pdf") do
    #Prawn::Document.generate("filename.pdf") do
      self.font_size = 6
      stroke do
        #line(bounds.bottom_left, bounds.bottom_right)
        #line(bounds.bottom_right, bounds.top_right)
        #line(bounds.top_right, bounds.top_left)
        #line(bounds.top_left, bounds.bottom_left)
#p filename
#text 'by_school_report_pdf'

        school_district = nil
        school = nil
        result = nil
        header_0 = nil
        header_1 = nil

        Document::Reports::BySchool.client_report_by_school( code_name, month, year , client_array , line_arrays )
        line_arrays.each{ |type,text_line|
          ignore = false
          ignore = true if type == :block or type == :whitespace
          if type == :school_district
            ignore = true
            school_district = text_line
          end

          if type == :header_0
            header_0 = text_line; ignore = true
          end
          if type == :header_1
            header_1 = text_line; ignore = true
          end
          if type == :school
            school = text_line; ignore = true
          end
          if type == :result
            result = text_line;ignore = true
          end

          if type == :school or type == :result
            ignore = true
            result_nil = result.nil?
            if !result_nil
              page_number += 1
              column_number = 0
              line_number = 0
            end
          end

          if type == :result
            Document::Reports::BySchool.print_header( self, page_number, header_0, header_1, school_district, school, result )
          end

          if !ignore
            Document::Reports::BySchool.print_line( self, page_number , column_number , line_number , text_line )
          end
 #text "page_number #{page_number} column_number #{column_number} line_number #{line_number} text: #{text_line}"
          if line_number > 80
            if column_number < 3
              column_number += 1
            else
              page_number += 1
              column_number = 0
              Document::Reports::BySchool.print_header( self, page_number, header_0, header_1, school_district, school, result )
            end
            line_number = 0
          else
            line_number += 1
          end
        }
        #Document::Reports::BySchool.print_page(self)
      end
    end
    return [] #text_lines
  end

  def self.client_report_by_school( code_name , month, year , client_array , lines = [] )
    lines << [:header_0,"As of #{Date.today} #{Time.now}"]
    lines << [:header_1,"Clients in School District #{code_name} By School:"]
    lines << [:whitespace," "]
    client_hash = Person::Client.by_school_hash( client_array )
    self.by_school_report( client_hash, month, year ) { |line|
      lines << line if line
    }
    return [] #lines
  end

  def self.by_school_report( results , month , year , &block )
        total_consumed_hours = 0
        results.each_key{ |sdn|
        yield :block, "++++++++++++++++++++++++++++++++"
        yield :school_district,"School District - #{sdn.to_s}"
        yield :block, "++++++++++++++++++++++++++++++++"
        yield :whitespace, ""
        results[sdn].each_key{ |scn|
          yield :block, "  ------------------------------"
          yield :school, "  School - #{scn.to_s}"
          yield :block, "  -------------------------------"
          #yield client.representative_total(4,results)
          #yield client.binder_total(4,results)
          Person::Client.result_types.each{ |rt|
              next if !results[sdn][scn][rt] or results[sdn][scn][rt].length == 0
              yield :whitespace, ""
              l="";4.times{ l<< ' ' };
              l<< "result => #{rt} - #{results[sdn][scn][rt].length}"
              yield :result, l
              l="";4.times{ l<< ' ' };
              l<< Person::Client.result_type_key[rt]
              yield  :whitespace, l if rt != :other
              results[sdn][scn][rt].each{ |client|
                if  client[:last_consumed_hour] and client[:last_consumed_hour].is_a? Fixnum
                  total_consumed_hours += client[:last_consumed_hour]
                end
                yield :client_data, client.client_line(6)
                yield :client_data, client.prep_line(6)
                yield :client_data, client.last_attended_line(8)
                yield :client_data, client.attendance_line(8)
                yield :client_data, client.updated_line(8)
                yield :client_data, client.phone_line(8)
                yield :client_data, client.result_line(8) if rt == :other
                yield :client_data, client.grade_line(8)
                yield :client_data, client.origin_line(8)
                #yield client.invoice_hrs_line(month,year,8)
                yield :client_data, client.representative_line(8)
                if ( ch = client.contract_hours_line(8) )
                  yield :client_data, ch
                end
                if ( cial = client.invoice_audit_line(8) )
                  yield :client_data, cial
                end
                yield :whitespace, ""
              }
          }
        }
      }
      yield :total, "Total Consumed Hours: #{total_consumed_hours}"
      yield :whitespace, ""
  end

end

