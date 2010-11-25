namespace :mlm do

  namespace :cache do

    desc "load"
    task :load  => :environment do
      Spreadsheet::MlmSplit.cache_load
    end

    desc "dump"
    task :dump  => :environment do
      p Spreadsheet::MlmSplit.cache_dump
    end

  end

  desc "hash"
  task :hash  => :environment do
    p "Hash:"
    Spreadsheet::MlmSplit.hash
  end

end

