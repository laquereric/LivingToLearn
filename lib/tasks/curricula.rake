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

    desc "Truncate Curricula tables"
    task(:truncate => :environment) do
      def truncate_table(config,table)
        begin
          case config["adapter"]
            when "mysql"
              ActiveRecord::Base.connection.execute("TRUNCATE #{table}")
            when "sqlite", "sqlite3"
              ActiveRecord::Base.connection.execute("DELETE FROM #{table}")
              ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence where name='#{table}'")
              ActiveRecord::Base.connection.execute("VACUUM")
          end
        rescue
          $stderr.puts "Error while truncating. Make sure you have a valid database.yml file and have created the database tables before running this command. You should be able to run rake db:migrate without an error"
        end
      end

      begin
        p "Connecting ..."
        config = ActiveRecord::Base.configurations[RAILS_ENV]
        ActiveRecord::Base.establish_connection
        Curriculum::Root.all_curricula_classes.each{ |curriculum_class|
          next if !curriculum_class.respond_to?(:table_name)
          table= curriculum_class.table_name
          p "Truncating #{curriculum_class.to_s} table : #{table}"
          #truncate_table(config,table)
        }
      rescue
          $stderr.puts "Error2 while truncating. Make sure you have a valid database.yml file and have created the database tables before running this command. You should be able to run rake db:migrate without an error"
       end
    end

end

