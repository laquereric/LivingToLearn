namespace :curricula do

    desc "Load"
    task :load => :environment do
      Curriculum::ParseCsv.purge
      Curriculum::CharacterJi.load_database_from_csv
      Curriculum::CcMath.load_database_from_csv
      Curriculum::CcReading.load_database_from_csv
      Curriculum::NjS21clc.load_database_from_csv
    end

    desc "cache"
    task :cache => :environment do
      #server= "http://LivingToLearn.com"
      server= "http://localhost:3001"

      root_url= "#{server}/curriculum/root"
      node_url_format= "#{server}/curriculum/x/%s"

      cmd_format= "wget %s --output-document=tmp/last_cached"

      %x{ wget #{ cmd_format % ( root_url ) } }

      CurriculumItem.all.each{ |ci|
        %x{ wget #{ cmd_format % (node_url_format % ci.id) }}
      }

    end

end

