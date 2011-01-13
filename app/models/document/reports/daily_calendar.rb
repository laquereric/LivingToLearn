class Document::Reports::DailyCalendar #< Document::Reports::TableTemplate

    def self.quick_for(day)
       index = 1
       Person::Client.each_client_schedule_for('THUR'){ |client,day_scheds|
         p "#{index} #{client.client_id.to_i} #{client.last_name}, #{client.first_name} #{day_scheds[0][:loc]} #{day_scheds[0][:hour]} #{day_scheds[0][:am_pm]}"
         index += 1
       }
    end

end

