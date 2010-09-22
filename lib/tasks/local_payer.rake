namespace :local_payer do
  namespace :store do
    desc "all"
    task :all => :environment do
      (0..6).each{ |s|
        fn= Spreadsheet::LocalPayers.get_section_filename(fn)
        Spreadsheet::LocalPayers.store(fn)
      }
    end
  end
end

