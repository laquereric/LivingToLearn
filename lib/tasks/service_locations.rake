namespace :service_locations do

    desc "Mantua Tutor Logs"
    task :mantua => :environment do
      p "Mantua Tutor Logs"
      target_service_location = Spreadsheet::TutoringClub::ServiceLocation.find_by_location_id('JMT')
      #appointments = Appointment::Recurring.all_at( target_service_location )
      Document::Reports::ByTutor.report( target_service_location )
    end

end

