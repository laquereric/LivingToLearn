namespace :curricula do

    desc "Load"
    task :load => :environment do
      Curriculum::ParseCsv.purge
      Curriculum::CharacterJi.load_database_from_csv
      Curriculum::CcMath.load_database_from_csv
      Curriculum::CcReading.load_database_from_csv
      Curriculum::NjS21clc.load_database_from_csv
    end

    desc "Cache all pages"
    task :cache => :environment do
      server= "http://LivingToLearn.com"
      #server= "http://localhost:3001"

      root_url= "#{server}/curriculum/root"
      node_url_format= "#{server}/curriculum/x/%s"

      cmd_format= "wget %s --output-document=tmp/last_cached"

      %x{ wget #{ cmd_format % ( root_url ) } }

      CurriculumItem.all.each{ |ci|
        %x{ wget #{ cmd_format % (node_url_format % ci.id) }}
      }

    end

    desc "Report items cached"
    task :cached_items => :environment do
      files = Dir.glob( File.join(Rails.root,"tmp","cache","**","*") )
      max_path = files.map{ |file| file.split('/').length }.max
      cached_items = files.select{ |file| file.split('/').length == max_path  }
      count = cached_items.length

      items = cached_items.map{ |file|
        last = file.split('/')[-1]
        last.gsub!('%2F','/')
        item = last.split('/')[-1]
        item.to_i
      }.sort
      p items.inspect

      p "#{count} Items Cached"
    end

end

