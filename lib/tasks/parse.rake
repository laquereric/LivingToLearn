namespace :parse do

  desc "Nj Schools"
  task :nj_schools  => :environment do
    Government::School.cache_nj()
  end

  desc "Nj School Cache"
  task :nj_school_cache  => :environment do
    p Government::School.nj_cache()
  end

  desc "Nj School Map Cache"
  task :nj_school_map_cache  => :environment do
    p Government::School.nj_map_cache()
  end

  desc "Nj School Districts"
  task :nj_school_districts  => :environment do
    Government::SchoolDistrict.cache_nj()
  end

  desc "Nj School Cache"
  task :nj_school_district_cache  => :environment do
    p Government::SchoolDistrict.nj_cache()
  end

  desc "Nj School Cache"
  task :nj_school_district_cache  => :environment do
    p Government::SchoolDistrict.nj_cache()
  end

end
