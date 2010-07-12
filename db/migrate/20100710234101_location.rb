class Location < ActiveRecord::Migration
  def self.up

    create_table "countries", :force => true do |t|
      t.references :government
    end

    create_table "states", :force => true do |t|
      t.references :government
      t.integer  "country_id"
    end

    create_table "counties", :force => true do |t|
      t.references :government
      t.integer  "state_id"
    end

    create_table "school_districts", :force => true do |t|
      t.references :government
      t.integer  "county_id"
    end

    create_table "school", :force => true do |t|
      t.references :government
      t.integer  "school_district_id"
    end

    create_table "township_boros", :force => true do |t|
      t.references :government
      t.integer  "county_id"
    end

    create_table "cities", :force => true do |t|
      t.references :government
      t.integer  "township_boro_id"
    end

    create_table "neighborhoods", :force => true do |t|
      t.references :government
      t.integer  "city_id"
    end

  end

  def self.down
    drop_table "countries"
    drop_table "states"
    drop_table "counties"
    drop_table "school_districts"
    drop_table "townships"
    drop_table "cities"
    drop_table "neighborhoods"
 end

end
