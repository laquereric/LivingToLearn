namespace :education_events do

  namespace :cache do

    desc "load"
    task :load  => :environment do
      Spreadsheet::EducationEvents.cache_load
    end

    desc "dump"
    task :dump  => :environment do
      p Spreadsheet::EducationEvents.cache_dump
    end

  end

  desc "report"
  task :report  => :environment do
     Government::SchoolDistrict.education_report()
  end

end

