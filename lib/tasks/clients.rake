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

  end

end

