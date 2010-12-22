namespace :update_cycle do

  namespace :monday_am do

    desc "Monday AM Worksheet"
    task :worksheet  => :environment do
      p "Update Cycle Monday AM Run (#{Time.now}):"
      target_period= Period.update_cycle(:monday_am)
      p "Target Period: #{target_period.inspect}"
      #GoogleApi::Calendar.cache_load
      p "1) Correct Missing Ids:"
      GoogleApi::Calendar.missing_ids.each{ |line| p line}

      GoogleApi::Calendar.each_event_in_period(target_period){ |c,e|
        p "#{GoogleApi::Calendar.event_stings(c,e).each{|l| p l}}"
      }
    end

      #GoogleApi::Calendar.each_event_in_period(Period.update_cycle(:monday_am) ){ |c,e|
      #  p "#{GoogleApi::Calendar.event_stings(c,e).each{|l| p l}}"
      #}
    #end

  end

end

