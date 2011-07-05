namespace :curricula do

    desc "Reload Database From CSV"
    task :load => :environment do
      Curriculum::Root.load_database_from_csvs
    end

    desc "Cache all pages"
    task :cache => :environment do
      CurriculumItem.all.each{ |ci|
        p "CurriculumItem #{ci.id}"
        ci.details= nil
        ci.get_details
      }
    end

    desc "Purge Cache"
    task :purge_cache => :environment do
      CurriculumItem.purge_caches
    end

end

