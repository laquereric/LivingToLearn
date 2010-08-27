# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

 # Put this in seeds.rb.  This is a full example
    # Run with 'rake db:seed', assuming you have already created
    # the table.
    # Works for mysql, sqlite, sqlite3
    def truncate_db_table(table)
      config = ActiveRecord::Base.configurations[Rails.env]
      ActiveRecord::Base.establish_connection
      case config["adapter"]
        when "mysql"
          ActiveRecord::Base.connection.execute("TRUNCATE #{table}")
        when "sqlite", "sqlite3"
          ActiveRecord::Base.connection.execute("DELETE FROM #{table}")
          ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence where name='#{table}'")
          ActiveRecord::Base.connection.execute("VACUUM")
      end
    end
 
    truncate_db_table(:entities)
    truncate_db_table(:entity_details)

    truncate_db_table(:government_countries)
    truncate_db_table(:government_states)
    truncate_db_table(:government_counties)
    truncate_db_table(:government_cities)
    truncate_db_table(:government_neighborhoods)
    truncate_db_table(:government_school_districts)
    truncate_db_table(:government_schools)
    truncate_db_table(:government_township_boros)
    truncate_db_table(:locations)
    truncate_db_table(:notes)

    truncate_db_table(:organization_partners)
    truncate_db_table(:organization_ses_provider)
    truncate_db_table(:person_partners)
    truncate_db_table(:person_superintendent)

