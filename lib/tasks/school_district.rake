namespace :school_district do

  namespace :ses_clients do
    desc "SES Contracts"
    task :contracts => :environment do
      Government::SchoolDistrict.each_district_with_ses_contract{ |d|
        p d.code_name
        p Contract::SchoolDistrict.get_for_sd(d)
      }
    end

    desc "Status Report"
    task :status_report => :environment do
      dropbox_session = Service::Dropbox.get_session
      Government::SchoolDistrict.each_district_with_ses_contract{ |d|
        p d.code_name
        d.store_clients_by_school(dropbox_session).each{ |l| p l }
      }
    end

    desc "Invoice spreadsheets Files"
    task :invoice_speadsheets => :environment do
      dropbox_session = Service::Dropbox.get_session
      Government::SchoolDistrict.each_district_with_ses_contract{ |d|
        #p d.code_name
        d.store_invoice_csv(Invoice.get[:period_month],Invoice.get[:period_year],dropbox_session).each{ |l| p l }
      }
    end

    desc "Invoices"
    task :invoices => :environment do
      dropbox_session = Service::Dropbox.get_session
      Government::SchoolDistrict.each_district_with_ses_contract{ |d|
        p d.code_name
        d.store_invoices(Invoice.get[:period_month],Invoice.get[:period_year],dropbox_session){ |l| 
          p l }
        }
    end

  end

end
