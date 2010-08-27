namespace :school_district do

  desc "CSV spreadsheet at cursor"
  task :csv => :environment do
    p "Dumpng Spreadsheet"

    sd= Government::SchoolDistrict.at_cursor()
    p "SchoolDistrict #{sd.name}"

    ss_key= Spreadsheet::Spreadsheet.get_cursor()
    p "Spreadsheet Key: #{ss_key}"

    sd.csv_spreadsheet(ss_key)
   
  end

  namespace :cursor do
    desc "Black Horse Pike Regional"
    task :black_horse_pike_regional_sd => :environment do
       sd= Government::SchoolDistrict.find_by_district_code(390)
       sd.set_cursor
    end
  end

end

