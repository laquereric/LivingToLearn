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
      ca = appointment.appointable.abbrev
      ca << "#{appointment.appointable.appointable_id.to_i} #{appointment.appointable.last_name}, #{appointment.appointable.first_name}"
      ca << ", d:#{appointment.duration}" if appointment.duration
      fill_color = appointment.appointable.color
      yield( :client_appointment , ca , fill_color )
      index += 1
    }
    yield( :location_time_total, location_time_total )
    yield( :day_total , index-1 )
    return index

  end

  def self.next_col( row , col , page , day_array )
    self.save_page_cell(  page , col , row , day_array )
    row = 0
    if col >= 6 then
      col = 0
      page += 1
    else
      col += 1
    end
    return row , col , page , []
  end

  def self.next_row( row , col , page , day_array )
    rows_per_column = 80
    row += 1
    if row < rows_per_column
      return row , col , page , day_array
    else
      return self.next_col( row , col , page , day_array )
    end
  end

  def self.get_page_data(&block)
    da = Appointment::Recurring.day_abbreviations
    sum = 0

    row = 1
    col = 0
    page = 0

    (0..6).each{ |day_num|
       day =  da[day_num]
       day_array = []
       self.quick_for( day ){ |ar|
         type = ar[0]
         text = ar[1]
         sum += text.to_i if type == :day_total
         day_array<< ar
         row , col , page , day_array = self.next_row( row , col , page, day_array )
       }
       row , col , page = self.next_col( row , col , page , day_array )
    }

    self.pages.each_index{ |page_index|
      self.header_lines = ["Weekly #{page_index+1}"]
      yield self.get_current_page_data(page_index)
    }

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
      pdf.fill_color "000000"
      case la[0]
        when :title
          pdf.font_size = 12
          pdf.text la[1]
        when  :appointment_location
          pdf.font_size = 6
          pdf.move_down(0.06.in)
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
            pdf.fill_color = la[2]
            pdf.text la[1]
          }
        when :day_total
          if la[1].to_i > 1
            pdf.move_down(0.12.in)
            pdf.font_size = 8
            pdf.text "Day Total : #{la[1].to_s}", :style => :bold
          end
      end
    }
  end

end

