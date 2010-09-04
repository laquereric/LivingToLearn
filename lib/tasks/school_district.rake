desc "ses_funding from google => write csv file"
task :ses_funding_google_csv => :environment do
   ss_filename= File.join('TutoringClub','Data','us_nj_ses_funding.gxls')
   csv_filename= File.join(RAILS_ROOT,'tmp','merge','US_NJ_SES_FUNDING.csv')
   Spreadsheet::SesFunding.csv_record_file(ss_filename,csv_filename)
end

desc "ses_funding from database => write csv file"
task :ses_funding_database_csv => :environment do
   csv_filename= File.join(RAILS_ROOT,'tmp','merge','US_NJ_SES_FUNDING.csv')
   sd= Government::SchoolDistrict.at_cursor()
   csv= Government::SchoolDistrict.csv_of_records( [sd] )
   File.open(csv_filename, 'w') { |f|
      f.write(csv)
   }
end

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
    desc "Paulsboro Boro"
    task :paulsboro_boro_sd => :environment do
       sd= Government::SchoolDistrict.find_by_district_code(4020)
       sd.set_cursor
    end
    desc "Monroe Township"
    task :monroe_township_sd => :environment do
       sd= Government::SchoolDistrict.find_by_district_code(3280)
       sd.set_cursor
    end
    desc "Clayton"
    task :clayton_sd => :environment do
       sd= Government::SchoolDistrict.find_by_district_code(860)
       sd.set_cursor
    end
    desc "Clearview"
    task :clearview_sd => :environment do
       sd= Government::SchoolDistrict.find_by_district_code(870)
       sd.set_cursor
    end
    desc "Camden Co Tech"
    task :black_horse_pike_regional_sd => :environment do
       sd= Government::SchoolDistrict.find_by_district_code(700)
       sd.set_cursor
    end
    desc "Gateway Regional"
    task :gateway_regional_sd => :environment do
       sd= Government::SchoolDistrict.find_by_district_code(1715)
       sd.set_cursor
    end
    desc "Blackhorse Pike Regional"
    task :blackhorse_pike_regional_sd => :environment do
       sd= Government::SchoolDistrict.find_by_district_code(390)
       sd.set_cursor
    end
    desc "Washington Township"
    task :washington_township_sd => :environment do
       sd= Government::SchoolDistrict.find_by_district_code(5500)
       sd.set_cursor
    end
    desc "Winslow"
    task :winslow_township_sd => :environment do
       sd= Government::SchoolDistrict.find_by_district_code(5820)
       sd.set_cursor
    end
    desc "Woodbury City"
    task :woodbury_city_sd => :environment do
       sd= Government::SchoolDistrict.find_by_district_code(5860)
       sd.set_cursor
    end
    desc "Glassboro"
    task :glassboro_sd => :environment do
       sd= Government::SchoolDistrict.find_by_district_code(1730)
       sd.set_cursor
    end
 
  end

end

