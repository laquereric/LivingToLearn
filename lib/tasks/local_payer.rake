namespace :local_payer do
  namespace :postcard do
    desc "t0"
    task :t0 => :environment do
      Communication::LocalPayers::RapidResults.new(0).produce
    end
    desc "t1"
    task :t1 => :environment do
      Communication::LocalPayers::RapidResults.new(0).produce
    end
     desc "t2"
    task :t2 => :environment do
      Communication::LocalPayers::RapidResults.new(0).produce
    end
     desc "t3"
    task :t3 => :environment do
      Communication::LocalPayers::RapidResults.new(0).produce
    end
     desc "t4"
    task :t4 => :environment do
      Communication::LocalPayers::RapidResults.new(0).produce
    end
     desc "t5"
    task :t5 => :environment do
      Communication::LocalPayers::RapidResults.new(0).produce
    end
     desc "t6"
    task :t6 => :environment do
      Communication::LocalPayers::RapidResults.new(0).produce
    end
  end
end

