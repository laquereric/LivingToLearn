class Document::Reports::DailyCalendar < Document::Reports::TableTemplate

  def self.table()

    return {
      :rows => 1,
      :columns => 7
    }

  end

  def self.quick_for( day_of_week , &block )

    index = 1
    yield( :title , "Day : #{day_of_week}" )
    last_location = nil
    last_hour = nil
    last_ampm = nil
    last_minute = nil
    location_time_total = 0
    Appointment::Recurring.all_on_weekday(day_of_week).each{ |appointment|
      minute = sprintf( "%02d", appointment[:minute] )
      time = "#{appointment[:hour]}:#{minute} #{appointment[:am_pm]}"
      if last_location != appointment[:loc] or
        last_hour != appointment[:hour] or
        last_ampm != appointment[:ampm] or
        last_minute != appointment[:minute]

        yield( :location_time_total, location_time_total ) if last_location

        last_location = appointment[:loc]
        last_hour = appointment[:hour]
        last_ampm = appointment[:ampm]
        last_minute = appointment[:minute]

        location_time_total = 0
        yield( :appointment_location ,  "#{ appointment[:loc] } at #{time}" )

      end
      location_time_total += 1
      ca = "#{appointment.client.client_id.to_i} #{appointment.client.last_name}, #{appointment.client.first_name}"
      yield( :client_appointment , ca )
      index += 1
    }
    yield( :location_time_total, location_time_total )
    yield( :day_total , index-1 )
    return index

  end

  def self.get_page_data(&block)
    da = Appointment::Recurring.day_abbreviations
    sum = 0
    [
       {:day =>  da[0], :row => 1, :col => 0},
       {:day =>  da[1], :row => 1, :col => 1},
       {:day =>  da[2], :row => 1, :col => 2},
       {:day =>  da[3], :row => 1 , :col => 3 },
       {:day =>  da[4], :row => 1 , :col => 4 },
       {:day =>  da[5], :row => 1 , :col => 5 },
       {:day =>  da[6], :row => 1 , :col=> 6 }
    ].each{ |h|
       day_array = []
       self.quick_for( h[:day] ){ |ar|
         type = ar[0]
         text = ar[1]
         sum += text.to_i if type == :day_total
         day_array<< ar
       }
       self.save_cell(  h[:col] , h[:row] , day_array )
    }
    self.header_lines=["Weekly"]
    yield self.get_current_page_data

  end

  def self.weekly()

    Prawn::Document.generate("weekly.pdf") do |pdf|
      first_page = true
      get_page_data{ |page_data|
        self.move_saved_to_page(pdf,page_data,!first_page)
        first_page = false
      }
    end
    return []

  end

  def self.print_cell(pdf,day_array)

    day_array.each{ |la|
      case la[0]
        when :title
          pdf.font_size = 12
          pdf.text la[1]
        when  :appointment_location
          pdf.font_size = 6
          pdf.text "#{la[1]}"
        when  :location_time_total
          if la[1].to_i > 1
            pdf.indent(0.06.in) {
              pdf.font_size = 4
              pdf.text "Location Time Total: #{ la[1] }", :style => :bold
            }
          end
        when :client_appointment
          pdf.indent(0.06.in) {
            pdf.font_size = 4
            pdf.text la[1]
          }
        when :day_total
          if la[1].to_i > 1
            pdf.font_size = 8
            pdf.text "Day Total : #{la[1].to_s}", :style => :bold
          end
      end
    }
  end

end

