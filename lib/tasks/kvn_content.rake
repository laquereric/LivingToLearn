namespace :kvn_content do

    desc "Push district static"
    task :district_static => :environment do
      Government::SchoolDistrictKvn.all.each{ |district|
        p ( dir = "public/KidsvilleNewsOfGloucesterCountyNj" )
        %x(mkdir -p #{dir})
        %x(wget --recursive --html-extension --convert-links --directory-prefix=#{dir} "http://localhost:3001/nj/gc/district_#{district.nickname}/site")
      }
    end

end

