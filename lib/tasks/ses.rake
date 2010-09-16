namespace :ses do
  namespace :postcard do
    desc "Schedule Hours"
    task :schedule_hours => :environment do
      Communication::Ses::ScheduleHours.new.produce
    end
  end

end

