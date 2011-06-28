namespace :curricula do

    desc "Load"
    task :load => :environment do
      Curriculum::ParseCsv.purge
      Curriculum::CharacterJi.load_database_from_csv
      Curriculum::CcMath.load_database_from_csv
      Curriculum::CcReading.load_database_from_csv
      Curriculum::NjS21clc.load_database_from_csv
    end

end

