namespace :school_district do

  namespace :ses_clients do

    desc "SES Contracts"
    task :contracts => :environment do
      Government::SchoolDistrict.each_district_with_ses_contract{ |d|
        p d.code_name
        p Contract::SchoolDistrict.get_for_sd(d)
      }
    end

    namespace :last_month do

      desc "Status Report"
      task :status_report => :environment do
        Government::SchoolDistric.status_report(:last_month)
      end

      desc "Invoice spreadsheets Files"
      task :invoice_speadsheets => :environment do
        Government::SchoolDistric.invoice_csv(:last_month)
      end

      desc "Invoices"
      task :invoices => :environment do
        Government::SchoolDistrict.invoice(:last_month)
      end

    end

    namespace :this_month do
      desc "Status Report"
      task :status_report => :environment do
        Government::SchoolDistric.status_report(:this_month)
      end

      desc "Invoice spreadsheets Files"
      task :invoice_speadsheets => :environment do
        Government::SchoolDistric.invoice_csv(:this_month)
      end

      desc "Invoices"
      task :invoices => :environment do
        Government::SchoolDistrict.invoice(:this_month)
      end
    end

  end

end
