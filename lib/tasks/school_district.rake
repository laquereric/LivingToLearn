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

  namespace :ses_clients do
    desc "SES Clients List"
    task :list => :environment do
      Government::SchoolDistrict.each_district_with_ses_contract{ |d|
        p d.code_name
        p Contract::SchoolDistrict.get_for_sd(d)
      }
    end

    desc "Store SES Clients By School"
    task :store_by_school => :environment do
      require 'dropbox'
      dropbox_session = if Service::Dropbox.logged_in?
        Service::Dropbox.session
      else
        nil
      end
      Government::SchoolDistrict.each_district_with_ses_contract{ |d|
        p d.code_name
        d.store_clients_by_school(dropbox_session).each{ |l| p l }
      }
    end

    desc "Invoice CSV File"
    task :invoice_csv => :environment do
      require 'dropbox'
      dropbox_session = if Service::Dropbox.logged_in?
        Service::Dropbox.session
      else
        nil
      end

      Government::SchoolDistrict.each_district_with_ses_contract{ |d|
        p d.code_name
        d.store_invoice_csv(Invoice.get[:period_month],Invoice.get[:period_year],dropbox_session).each{ |l| p l }
      }
    end

  end

end

