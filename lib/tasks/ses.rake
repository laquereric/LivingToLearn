namespace :ses do
  desc "Records Only"
  task :records_only_tutor_letters => :environment do
    Person::Employee.all.select{ |e| e.records_only? }.each{ |tutor|
      Document::Letter::RecordsOnlyTutor.print_for(tutor)
    }
  end

  desc "Lump Sum"
  task :lump_sum_tutor_letters => :environment do
    Person::Employee.all.select{ |e| e.lump_sum? }.each{ |tutor|
      Document::Letter::LumpSumTutor.print_for(tutor)
    }
  end

  desc "Records Only"
  task :records_only_tutor_letters => :environment do
    Person::Employee.all.select{ |e| e.lump_sum? }.each{ |tutor|
      Document::Letter::RecordsOnkyTutor.print_for(tutor)
    }
  end

  namespace :postcard do
    desc "Schedule Hours"
    task :schedule_hours => :environment do
      Communication::Ses::ScheduleHours.new.produce
    end
  end

  namespace :postcard do
    desc "Come To Tutoring"
    task :come_to_tutoring => :environment do
      Communication::Ses::ComeToTutoring.new.produce
    end
  end

  namespace :postcard do
    desc "ThanksWaiting"
    task :thanks_waiting => :environment do
      Communication::Ses::ThanksWaiting.new.produce
    end
  end

  namespace :postcard do
    desc "StillWaiting"
    task :still_waiting => :environment do
      Communication::Ses::StillWaiting.new.produce
    end
  end

end

