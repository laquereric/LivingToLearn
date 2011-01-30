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
      p "id first_name last_name mnemonic"
      #Spreadsheet::EmployeeList.each_employee{ |employee|
      Person::Employee.all.each{ |employee|
        r = []
        r<< "#{ employee[:payroll_number].to_i } "
        r<< "#{ employee[:first_name] } "
        r<< "#{ employee[:last_name] } "
        r<< "#{ employee.mnemonic }"
        p r.join(" ")
      }
    end

  end

end

