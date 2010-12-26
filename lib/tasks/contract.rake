namespace :contracts do

  desc "School District Contract List"
  task :school_district_list => :environment do
    p "School District Contract List"
    Contract::SchoolDistrict.each{ |sdc|
      p sdc
      #Contract::SchoolDistrict.send("get_#{sdc.}")
    }
  end

end

