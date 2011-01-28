namespace :tutoring_club do

  namespace :service_locations do

    desc "Get Migration"
    task :get_migration => :environment do
      p "Get Migration"
      mls = Spreadsheet::Spreadsheet.get_migration_from_google_spreadsheet(["TutoringClub","ServiceLocations"])
      mls.each{ |l|  p l}
    end

    desc "Get Class Def"
    task :get_class_def => :environment do
      p "Get Class Def"
      mls = Spreadsheet::Spreadsheet.get_class_def_from_google_spreadsheet(["TutoringClub","ServiceLocations"])
      mls.each{ |l|  p l}
    end

    desc "Load Records"
    task :load_records => :environment do
      p "Loading Records"
      mls = Spreadsheet::TutoringClub::ServiceLocation.get_records_from_google_spreadsheet
      mls.each{ |l|  p l}
    end

  end

end

