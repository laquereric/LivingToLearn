namespace :kvn_content do
    desc "Push district static"
    task :district_static => :environment do
      Government::SchoolDistrictKvn.all.each{ |district|
        district.schools.each{ |school|
          p ( dir = "public/KidsvilleNewsOfGloucesterCountyNj/nj/gc/district_#{district.nickname}/school_#{school.nickname}" )
          p ( file = "public/KidsvilleNewsOfGloucesterCountyNj/nj/gc/district_#{district.nickname}/school_#{school.nickname}/index.html" )
          %x(mkdir -p #{dir})
          %x(wget --output-document=#{file} http://localhost:3001/nj/gc/district_#{district.nickname})
        }
      }
    end

    desc "Push school static"
    task :school_static => :environment do
      p "Pushing Sites"
      Government::SchoolDistrictKvn.all.each{ |district|
        district.schools.each{ |school|
          p ( dir = "public/KidsvilleNewsOfGloucesterCountyNj/nj/gc/district_#{district.nickname}/school_#{school.nickname}" )
          p ( file = "public/KidsvilleNewsOfGloucesterCountyNj/nj/gc/district_#{district.nickname}/school_#{school.nickname}/index.html" )
          %x(mkdir -p #{dir})
          %x(wget --output-document=#{file} http://localhost:3001/nj/gc/district_#{district.nickname})
        }
      }
    end

end

