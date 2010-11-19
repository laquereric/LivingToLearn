namespace :clients do

  namespace :cache do

    desc "load"
    task :load  => :environment do
      Spreadsheet::CurrentClients.cache_load
    end

    desc "dump"
    task :dump  => :environment do
      p Spreadsheet::CurrentClients.cache_dump
    end

  end

  namespace :list do

    desc "names"
    task :names  => :environment do
      p "Names:"
      Spreadsheet::CurrentClients.each_client{ |client|
        p "id: #{ client[:client_id].to_i }"
        p "first_name: #{ client[:first_name] }"
        p "last_name: #{ client[:last_name] }"
      }
    end

    desc "contract_or_revenue"
    task :contract_or_revenue  => :environment do
      p "Contract or Revenue:"
      Spreadsheet::CurrentClients.each_client{ |client|
        next if client[:result] != 'contract' and client[:result] != 'revenue'
        p "#{ client[:school_district] } => #{client[:result]} #{ client[:client_id].to_i } #{ client[:last_name] } , #{ client[:first_name] }"
     }
    end

    desc "contract"
    task :contract  => :environment do
      p "Contract:"
      Spreadsheet::CurrentClients.each_client{ |client|
        next if client[:result] != 'contract'
        p "id: #{ client[:school_district] } => #{ client[:client_id].to_i } #{ client[:last_name] } , #{ client[:first_name] }"
     }
    end

    desc "parent_pay"
    task :parent_pay  => :environment do
      p "Parent Pay:"
      Spreadsheet::CurrentClients.each_client{ |client|
        next if client[:result] != 'parent_pay'
        p "id: #{ client[:client_id].to_i } #{ client[:last_name] } , #{ client[:first_name] }"
     }
    end

    desc "revenue"
    task :revenue  => :environment do
      p "Revenue:"
      Spreadsheet::CurrentClients.each_client{ |client|
        next if client[:result] != 'revenue'
        p "id: #{ client[:school_district] } => #{ client[:client_id].to_i } #{ client[:last_name] } , #{ client[:first_name] }"
     }
    end

  end

end

