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

    desc "by_origin"
    task :by_origin  => :environment do
      p "By Origin:"
      results= {}
      Spreadsheet::CurrentClients.each_client{ |client|
        origin = client[:origin]
p origin
        origin = 'unknown' if origin.nil? or  origin.length == 0
        origin= origin.to_s.underscore.to_sym if client[:origin]
        origin = :other if client[:origin].nil?
        line= "#{client[:school_district]} #{ client[:client_id].to_i } #{ client[:last_name] } , #{ client[:first_name]}"
        results[origin] = [] if results[origin].nil?
        results[origin]<< line
      }
      results.each_key{ |origin|
        p "origin: #{origin}"
        results[origin].each{ |line|
          p "    #{line}"
        }
      }
    end

    desc "by_result"
    task :by_result  => :environment do
      p "By Result:"
      results= {}
      Spreadsheet::CurrentClients.each_client{ |client|
        result= client[:result].to_sym if client[:result]
        #next if result and result != :contract and result != :revenue
        result= :other if result and result != :contract and result != :revenue
        line= "#{ client[:client_id].to_i } #{ client[:last_name] } , #{ client[:first_name]}"
        sd= client[:school_district]
        results[sd] = { :contract => [], :revenue => [] , :other => [] } if results[sd].nil?
        results[sd][:contract]<< line if result == :contract 
        results[sd][:revenue]<< line if result == :revenue 
        results[sd][:other]<< line if result == :other 
      }
      results.each_key{ |sdn|
        p sdn
        p "  contract"
        results[sdn][:contract].each{ |line|
          p "    #{line}"
        }
        p "  revenue"
        results[sdn][:revenue].each{ |line|
          p "    #{line}"
        }
        p "  other"
        results[sdn][:other].each{ |line|
          p "    #{line}"
        }
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

