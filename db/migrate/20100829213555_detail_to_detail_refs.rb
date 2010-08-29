class DetailToDetailRefs < ActiveRecord::Migration

  def self.up
    rename_column "person_pto_member", 'government_school_entity_id' , 'government_school_detail_id'
    rename_column "person_school_district_administrator", 'government_school_district_entity_id' , 'government_school_district_detail_id'
  end

  def self.down
    rename_column "person_pto_member", 'government_school_detail_id', 'government_school_entity_id' 
    rename_column "person_school_district_administrator",'government_school_district','government_school_district_entity_id' 
  end

end
