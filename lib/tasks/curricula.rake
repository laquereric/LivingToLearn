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
      wget 'http://LivingToLearn.com/curriculum/root' -o 'tmp/last_wget' --output-document='tmp/last_cached'
      CurriculumItem.all.each{ |ci|
        wget "http://LivingToLearn.com/curriculum/x/#{ci.id} -o 'tmp/last_wget' --output-document='tmp/last_cached'
      }
    end

end

