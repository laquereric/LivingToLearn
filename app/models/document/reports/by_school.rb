require 'prawn'
require "prawn/measurement_extensions"

class Document::Reports::BySchool

  def self.print_by_school_report_pdf( code_name, local_directory , filename , client_array , month , year )
    client_hash = Person::Client.by_school_hash( client_array )
    Prawn::Document.generate(filename) do
      stroke do
        line(bounds.bottom_left, bounds.bottom_right)
        line(bounds.bottom_right, bounds.top_right)
        line(bounds.top_right, bounds.top_left)
        line(bounds.top_left, bounds.bottom_left)
      end
    end
  end

  def self.print_by_school_report( code_name, local_directory , filename , client_array , month , year )
    lines = []
    status_lines = []
    status= "Stored Report to #{local_directory}"
    lines << status
    status_lines << status

    lines<< " "
    client_report_by_school( code_name, month, year , client_array , lines = [] )

    File.open(filename,'w+') do |file|
      lines.flatten.each{ |line|
        file.puts line
       }
    end
  end

  def self.client_report_by_school( code_name , month, year , client_array , lines = [] )
    lines << "As of #{Date.today} #{Time.now}"
    lines << "Clients in School District #{code_name} By School:"
    lines << " "
    client_hash = Person::Client.by_school_hash( client_array )
    self.by_school_report( client_hash, month, year ) { |line|
      lines << line if line
    }
    return lines
  end

  def self.by_school_report( results , month , year , &block )
        total_consumed_hours = 0
        results.each_key{ |sdn|
        "++++++++++++++++++++++++++++++++"
        yield "School District - #{sdn.to_s}"
        yield "++++++++++++++++++++++++++++++++"
        yield ""
        results[sdn].each_key{ |scn|
          yield "  ------------------------------"
          yield "  School - #{scn.to_s}"
          yield "  -------------------------------"
          #yield client.representative_total(4,results)
          #yield client.binder_total(4,results)
          Person::Client.result_types.each{ |rt|
              next if !results[sdn][scn][rt] or results[sdn][scn][rt].length == 0
              yield ""
              l="";4.times{ l<< ' ' };
              l<< "result => #{rt} - #{results[sdn][scn][rt].length}"
              yield l
              l="";4.times{ l<< ' ' };
              l<< Person::Client.result_type_key[rt]
              yield l if rt != :other
              results[sdn][scn][rt].each{ |client|
                if  client[:last_consumed_hour] and client[:last_consumed_hour].is_a? Fixnum
                  total_consumed_hours += client[:last_consumed_hour]
                end
                yield client.client_line(6)
                yield client.prep_line(6)
                yield client.last_attended_line(8)
                yield client.attendance_line(8)
                yield client.updated_line(8)
                yield client.phone_line(8)
                yield client.result_line(8) if rt == :other
                yield client.grade_line(8)
                yield client.origin_line(8)
                yield client.invoice_hrs_line(month,year,8)
                yield client.representative_line(8)
                if ( ch = client.contract_hours_line(8) )
                  yield ch
                end
                if ( cial = client.invoice_audit_line(8) )
                  yield cial
                end
                yield ""
              }
          }
        }
      }
      yield "Total Consumed Hours: #{total_consumed_hours}"
      yield ""
  end

end

