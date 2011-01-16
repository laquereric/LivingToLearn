class Document::Reports::DailyCalendar < Document::Reports::TableTemplate

  def self.quick_for(day,&block)

    index = 1
    yield( :title , "Day : #{day}" )
    Person::Client.each_client_schedule_for(day){ |client,day_scheds|
      r = "  #{index} #{client.client_id.to_i} #{client.last_name}, #{client.first_name}"
      r << "#{day_scheds[0][:loc]} #{day_scheds[0][:hour]} #{day_scheds[0][:am_pm]}"
      yield( :client_appintment , r )
      index += 1
    }
    yield( :day_total , index )
    return index
  end

  def self.get_page_data(&block)

    sum = 0
    [
       {:day =>"SUN" , :row => 1,:col => 0},
       {:day => "MON" , :row => 1,:col => 1},
       {:day => "TU", :row => 1,:col => 2},
       {:day => "WED" , :row => 2 , :col => 0 },
       {:day => "THUR" , :row => 2 , :col => 1 },
       {:day => "FRI",:row => 2 , :col => 2 },
       {:day => "SAT" , :row => 3 , :col=> 0 }
    ].each{ |h|
       day_array = []
       self.quick_for( h[:day] ){ |type,text|
         sum += text.to_i if type == :day_total
         day_array<< [type,text]
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

    title = day_array.select { |la| la[0] == :title}[0][1]
    day_total = day_array.select { |la| la[0] == :day_total}[0][1]
    client_appintments = []; client_appintments << day_array.select { |la| la[0] == :client_appintment }.map{ |l| l[1]}

    pdf.font_size = 12
    pdf.text title.inspect

    pdf.font_size = 4
    client_appintments[0].each{ |ca|
      pdf.text ca.inspect
    }

    pdf.text ' '
    pdf.text day_total.inspect

  end

end

