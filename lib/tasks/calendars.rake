namespace :calendars do

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
    desc "dump"
    task :dump => :environment do
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

