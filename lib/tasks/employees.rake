namespace :employees do

  namespace :cache do

    desc "load"
    task :load  => :environment do
      Spreadsheet::EmployeeList.cache_load
    end

    desc "dump"
    task :dump  => :environment do
      p Spreadsheet::EmployeeList.cache_dump
    end

  end

  namespace :list do

    desc "names"
    task :names  => :environment do
      p "Names:"
      Spreadsheet::EmployeeList.each_employee{ |employee|
        p "id: #{ employee[:payroll_number].to_i }"
        p "parent_id: #{ employee[:parent_payroll_number].to_i }"
        p "first_name: #{ employee[:first_name] }"
        p "last_name: #{ employee[:last_name] }"
      }
    end

  end

end

