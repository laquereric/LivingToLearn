class PersonSchoolDistrictAdministrator < ActiveRecord::Migration

  def self.up
    rename_column :person_school_district_administrator, :school_district_entity_id, :government_school_district_entity_id
  end

  def self.down
    rename_column :person_school_district_administrator, :government_school_district_entity_id, :school_district_entity_id
  end

end
