namespace :calendars do
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

end

