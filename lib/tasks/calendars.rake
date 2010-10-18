namespace :calendar do

  namespace :events_in_period do

    desc "today"
    task :today  => :environment do
      p "Events Today (#{Time.now}):"
       GoogleApi::Calendar.each_event_in_period(Period.today){ |c,e|
        p "#{GoogleApi::Calendar.event_stings(c,e).each{|l| p l}}"
      }
    end

    desc "tomorrow"
    task :tomorrow  => :environment do
      p "Events Tomorrow (#{Time.now}):"
      GoogleApi::Calendar.each_event_in_period(Period.tomorrow){ |c,e|
        p "#{GoogleApi::Calendar.event_stings(c,e).each{|l| p l}}"
      }
    end

  end

  namespace :list do

    desc "titles"
    task :titles  => :environment do
      p "Titles:"
      l= GoogleApi::Calendar.cache_dump.values.keys
      l.each{ |k| p k }
    end


    desc "missing_id"
    task :missing_id  => :environment do
      p "Missing Ids:"
      l= GoogleApi::Calendar.cache_dump.keys.select{ |k| /xx/.match(k) }
      l.each{ |m_id| p m_id }
    end

    desc "client_ids"
    task :client_ids  => :environment do
      p "Client Ids:"
      l= GoogleApi::Calendar.cache_dump.values.map{ |c| c[:client_id] }.compact
      l.each{ |c_id| p c_id }
    end

    desc "tutors"
    task :tutor_ids  => :environment do
      p "Tutor Ids:"
      l= GoogleApi::Calendar.cache_dump.values.map{ |c| c[:tutor_id] }.compact
      l.each{ |t_id| p t_id }
    end

  end

  namespace :cache do

    desc "load"
    task :load  => :environment do
      GoogleApi::Calendar.cache_load
    end

    desc "dump"
    task :dump  => :environment do
      p "read: #{Rails.cache_dump}"
    end

  end

  namespace :ses_highland do
    desc "dump"
    task :dump => :environment do

      tch= GoogleApi::Calendar.get_tutor_calendar_hash
      tutor_calendars= [56,57].map{ |cid| tch[cid] }
p "tutor_calendars: #{tutor_calendars.inspect}"

      cch= GoogleApi::Calendar.get_client_calendar_hash
      client_calendars= [30,18,23,24].map{ |cid| cch[cid] }
p "client_calendars: #{client_calendars.inspect}"
    end
  end

  namespace :clients do
    desc "tomorrow"
    task :tomorrow => :environment do
      GoogleApi::Calendar.period= Period.tomorrow
      GoogleApi::Calendar.client_ids= [30]
      h= GoogleApi::Calendar.get_client_calendar_hash
      h.each_pair{ |client_id,calendar|
        p "Calendar for Client ID #{client_id}:"
        p GoogleApi::Calendar.hash(calendar)
      }
    end

    desc "dump"
    task :dump => :environment do
      GoogleApi::Calendar.period= nil
      h= GoogleApi::Calendar.get_client_calendar_hash
      h.each_pair{ |client_id,calendar|
        p "Calendar for Client ID #{client_id}:"
        p GoogleApi::Calendar.hash(calendar)
      }
    end
  end

  namespace :tutors do
    desc "dump"
    task :dump => :environment do
      h= GoogleApi::Calendar.get_tutor_calendar_hash
      h.each_pair{ |tutor_id,calendar|
        p "Calendar for Tutor ID #{tutor_id}:"
        p GoogleApi::Calendar.hash(calendar)
      }
    end
  end

  namespace :dead do
    desc "dump"
    task :dump => :environment do
      h= GoogleApi::Calendar.get_dead_calendar_hash
      h.each_pair{ |tutor_id,calendar|
        p "Calendar for Dead ID #{tutor_id}:"
        p GoogleApi::Calendar.hash(calendar)
      }
    end
  end

end

