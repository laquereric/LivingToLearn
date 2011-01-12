require 'prawn'
require "prawn/measurement_extensions"

class Document::Reports::BySchool

  cattr_accessor :last_page
  cattr_accessor :last_column
  cattr_accessor :last_line

  cattr_accessor :header_lines
  cattr_accessor :columns

#################################
# Layout
#################################

  def self.table()
    return {
      :rows => 4,
      :columns => 4
    }
  end

  def self.header_bounding_box(doc,&block)
    doc.font_size = 10
    doc.bounding_box([doc.bounds.left,doc.bounds.top+0.25.in], :width => 7.5.in, :height => 1.in) {
      doc.stroke_bounds
      doc.indent(10) {
        yield doc
      }
    }
  end

  def self.cell_bounding_box_for(doc,row,column,&block)
    doc.font_size = 6
    width = 1.75.in
    height = 2.in
    x_offset = doc.bounds.left + (column*(width+0.125.in) )
    y_offset = doc.bounds.top - 1.in - ( row * ( height + 0.125.in ) )
    doc.bounding_box([x_offset,y_offset], :width => width, :height => height) do
      doc.stroke_bounds
      doc.indent(5) {
        yield doc
      }
    end
  end

#################################
# Data
#################################

  def self.get_current_page_data
    { :header_lines => self.header_lines, :columns => self.columns }
  end

  def self.reset_current_page_data
    self.header_lines = []
    self.columns = []
  end

  def self.get_page_data(code_name, local_directory , filename , client_array , month , year, &block)

        school_district = nil
        school = nil
        result = nil
        header_0 = nil
        header_1 = nil

        page_number = 0
        column_number = 0
        row_number = 0

        self.reset_current_page_data

        line_arrays= []
        Document::Reports::BySchool.client_report_by_school( code_name, month, year , client_array , line_arrays )
        line_arrays.each{ |type,text_line|
          next if type == :client_data

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
              yield self.get_current_page_data if page_number != 0
              self.reset_current_page_data
              page_number += 1
              column_number = 0
              row_number = 0
            end
          end

          if type == :result
            Document::Reports::BySchool.print_header( self, page_number, header_0, header_1, school_district, school, result )
          end

          if type == :client_object
            Document::Reports::BySchool.save_cell( column_number , row_number , text_line )
          end

          if row_number >= Document::Reports::BySchool.table[:rows]
            if column_number < 3
              column_number += 1
            else
              page_number += 1
              column_number = 0
              Document::Reports::BySchool.print_header( self, page_number, header_0, header_1, school_district, school, result )
            end
            row_number = 0
          else
            row_number += 1
          end
        }
        yield self.get_current_page_data

  end

#####################################
# Send Client Data to Cell
######################################
  def self.client_data(client,&block)
              if  client[:last_consumed_hour] and client[:last_consumed_hour].is_a? Fixnum
                  total_consumed_hours += client[:last_consumed_hour]
                end
                yield :client_data, client.client_line(6)
                yield :client_data, client.prep_line(6)
                yield :client_data, client.last_attended_line(8)
                yield :client_data, client.attendance_line(8)
                yield :client_data, client.updated_line(8)
                yield :client_data, client.phone_line(8)
                #yield :client_data, client.result_line(8) if rt == :other
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

  end

  def self.print_cell(pdf,client)
    client_data(client){ |line|
      pdf.text line[1]
    }
  end

#####################################
# Send Data to Page
######################################

  def self.print_page(pdf,page_data,new_page=true)
    pdf.start_new_page if new_page
    pdf.stroke do
        Document::Reports::BySchool.header_bounding_box(pdf){
          page_data[:header_lines].each{ |header_line|
            pdf.text header_line
          }
        }
        (0..Document::Reports::BySchool.table[:columns]-1).each{ |column|
          next if page_data[:columns].nil?
          column_data = page_data[:columns][column] if page_data
          (0..Document::Reports::BySchool.table[:rows]-1).each{ |row|
            row_data = column_data[row] if column_data
            Document::Reports::BySchool.cell_bounding_box_for(pdf,row,column){
              Document::Reports::BySchool.print_cell(pdf,row_data)  if row_data
            }
          }
        }
    end
  end

  def self.save_cell( column_number , row_number , hash )
    self.columns ||= []
    self.columns[column_number] ||= []
    self.columns[column_number]<< hash
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
        #self.print_page(doc)
        self.columns = nil
      end
      self.header_lines = [ header_0, header_1, school_district, school, result]
    end

  end
##########################
#
###########################
  def self.print_by_school_report( code_name, local_directory , filename , client_array , month , year, mode= :do )

    result= nil
    Prawn::Document.generate("#{filename}.pdf") do |pdf|
      first_page = true
      get_page_data(code_name, local_directory , filename , client_array , month , year) { |page_data|
        Document::Reports::BySchool.print_page(pdf,page_data,!first_page)
        first_page = false
      }
    end
    return []
  end

  def self.client_report_by_school( code_name , month, year , client_array , lines = [] )
    lines << [:header_0,"As of #{Date.today} #{Time.now}"]
    lines << [:header_1,"Clients in School District #{code_name} By School:"]
    lines << [:whitespace," "]
    client_hash = Person::Client.by_school_hash( client_array )
    self.by_school_report( client_hash, month, year ) { |line|
      lines << line if line
    }
    return []
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
                yield :client_object,client
              }
          }
        }
      }
      yield :total, "Total Consumed Hours: #{total_consumed_hours}"
      yield :whitespace, ""
  end

end

