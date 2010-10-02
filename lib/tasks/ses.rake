namespace :ses do
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

end

