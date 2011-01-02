namespace :school_district do

  namespace :ses_clients do

    desc "SES Contracts"
    task :contracts => :environment do
      Government::SchoolDistrict.each_district_with_ses_contract{ |d|
        p d.code_name
        p Contract::SchoolDistrict.get_for_sd(d)
      }
    end

    desc "Catchup"
    task :catchup => :environment do
      [2010].each{ |year|
        [9,10,11,12].each{ |month|
          Government::SchoolDistrict.invoice_csv_for( month , year )
          Government::SchoolDistrict.invoices_for( month , year )
        }
      }
=begin
      [2011].each{ |year|
        [9,10,11,12].each{ |month|
          Government::SchoolDistrict.invoice_csv_for( month , year )
          Government::SchoolDistrict.invoices_for( month , year )
        }
      }
=end
    end
    
    namespace :last_last_month do
      desc "Status Report"
      task :status_report => :environment do
        invoice = Invoice.get_for_month_type(:last_month)
        Government::SchoolDistrict.status_report_for( invoice[:period_month],invoice[:period_year] )
      end

      desc "Invoice spreadsheets Files"
      task :invoice_speadsheets => :environment do
        invoice = Invoice.get_for_month_type(:last_month)
        Government::SchoolDistrict.invoice_csv_for( invoice[:period_month] , invoice[:period_year] )
      end

      desc "Invoices"
      task :invoices => :environment do
        invoice = Invoice.get_for_month_type(:last_month)
p invoice.inspect
        Government::SchoolDistrict.invoices_for( invoice[:period_month] , invoice[:period_year] )
      end

    end

    namespace :last_month do
      desc "Status Report"
      task :status_report => :environment do
        invoice = Invoice.get_for_month_type(:last_month)
        Government::SchoolDistrict.status_report_for( invoice[:period_month],invoice[:period_year] )
      end

      desc "Invoice spreadsheets Files"
      task :invoice_speadsheets => :environment do
        invoice = Invoice.get_for_month_type(:last_month)
        Government::SchoolDistrict.invoice_csv_for( invoice[:period_month] , invoice[:period_year] )
      end

      desc "Invoices"
      task :invoices => :environment do
        invoice = Invoice.get_for_month_type(:last_month)
p invoice.inspect
        Government::SchoolDistrict.invoices_for( invoice[:period_month] , invoice[:period_year] )
      end

    end

    namespace :this_month do
      desc "Status Report"
      task :status_report => :environment do
        invoice = Invoice.get_for_month_type(:this_month)
        Government::SchoolDistrict.status_report_for( invoice[:period_month] , invoice[:period_year] )
      end

      desc "Invoice spreadsheets Files"
      task :invoice_speadsheets => :environment do
        invoice = Invoice.get_for_month_type(:this_month)
        Government::SchoolDistrict.invoice_csv_for( invoice[:period_month] , invoice[:period_year] )
      end

      desc "Invoices"
      task :invoices => :environment do
        invoice = Invoice.get_for_month_type(:this_month)
        Government::SchoolDistrict.invoices_for( invoice[:period_month] , invoice[:period_year] )
      end
    end

  end

end
