class SdCodeFix < ActiveRecord::Migration
  def self.up
    all_hash=[]
#p '1'
    #Government::SchoolDistrict.all.each{ |sd| all_hash[sd.id] = sd }
#p '2'
     #remove_column :government_school_districts, :government_district_code
#p '3'
     #add_column :government_school_districts, :government_district_code, :string
#p '4'
    Government::SchoolDistrict.all.each{ |sd|
      gdc= sd.district_code 
      if gdc < 100
        p gdc
        p "00#{gdc}"
        sd.government_district_code="00#{gdc}"
        sd.save!
      elsif gdc < 1000
        p gdc
        p "0#{gdc}"
        sd.government_district_code="0#{gdc}"
        sd.save!
      end
    }
 
  end

  def self.down
  end
end
