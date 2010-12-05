namespace :parse do

  desc "Nj Schools"
  task :nj_schools  => :environment do
    Government::School.cache_nj()
  end

  desc "Nj School Cache"
  task :nj_school_cache  => :environment do
    p Government::School.nj_school_cache()
  end

end
