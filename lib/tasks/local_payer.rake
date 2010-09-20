namespace :local_payer do
  namespace :store do
    desc "t0"
    task :t0 => :environment do
      fn0= Spreadsheet::LocalPayers.get_section_filename(0)
      Spreadsheet::LocalPayers.store(fn0)
    end
    desc "t1"
    task :t1 => :environment do
      fn1= Spreadsheet::LocalPayers.get_section_filename(1)
      Spreadsheet::LocalPayers.store(fn1)
    end
    desc "t2"
    task :t2 => :environment do
      fn2= Spreadsheet::LocalPayers.get_section_filename(2)
      Spreadsheet::LocalPayers.store(fn2)
    end
    desc "t3"
    task :t3 => :environment do
      fn3= Spreadsheet::LocalPayers.get_section_filename(3)
      Spreadsheet::LocalPayers.store(fn3)
    end
    desc "t4"
    task :t4 => :environment do
      fn1= Spreadsheet::LocalPayers.get_section_filename(4)
      Spreadsheet::LocalPayers.store(fn4)
    end
    desc "t5"
    task :t5 => :environment do
      fn5= Spreadsheet::LocalPayers.get_section_filename(5)
      Spreadsheet::LocalPayers.store(fn5)
    end
    desc "t6"
    task :t6 => :environment do
      fn6= Spreadsheet::LocalPayers.get_section_filename(6)
      Spreadsheet::LocalPayers.store(fn6)
    end
  end
end

