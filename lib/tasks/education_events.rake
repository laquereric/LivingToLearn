namespace :education_events do

  namespace :cache do

    desc "Load"
    task :load  => :environment do
      Spreadsheet::EducationEvents.cache_load
    end

    desc "Dump"
    task :dump  => :environment do
      p Spreadsheet::EducationEvents.cache_dump
    end

  end

  desc "Report"
  task :report  => :environment do
     Government::SchoolDistrict.education_report()
  end

end

