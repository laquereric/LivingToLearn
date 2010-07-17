class ImportSesFunding < ActiveRecord::Migration

  def self.up

    add_column :government_states, :government_country_id, :integer

    add_column :government_counties, :government_state_id, :integer
    add_column :government_counties, :government_country_id, :integer

    add_column :government_school_districts, :government_country_id, :integer
    add_column :government_school_districts, :government_state_id, :integer
    rename_column :government_school_districts, :county_id, :government_county_id
    add_column :government_school_districts, :district_code, :integer
 
    add_column :government_school_districts, :at_risk_pupils_fy2010, :decimal, :precision => 8, :scale => 2
    add_column :government_school_districts, :poverty_pupils_fy2010, :decimal, :precision => 8, :scale => 2
    add_column :government_school_districts, :arra_allocation_fy2010, :decimal, :precision => 8, :scale => 2
    add_column :government_school_districts, :ses_allocation_fy2010, :decimal, :precision => 8, :scale => 2

    add_column :government_school_districts, :at_risk_pupils_fy2011, :decimal, :precision => 8, :scale => 2
    add_column :government_school_districts, :poverty_pupils_fy2011, :decimal, :precision => 8, :scale => 2
    add_column :government_school_districts, :arra_allocation_fy2011, :decimal, :precision => 8, :scale => 2
    add_column :government_school_districts, :ses_allocation_fy2011, :decimal, :precision => 8, :scale => 2
  end

  def self.down
    remove_column :government_states, :government_country_id

    remove_column :government_counties, :government_state_id
    remove_column :government_counties, :government_country_id

    remove_column :government_school_districts, :government_country_id
    remove_column :government_school_districts, :government_state_id
    rename_column :government_school_districts, :government_county_id, :county_id
    remove_column :government_school_districts, :district_code
    
    remove_column :government_school_districts, :at_risk_pupils_fy2010
    remove_column :government_school_districts, :poverty_pupils_fy2010
    remove_column :government_school_districts, :arra_allocation_fy2010
    remove_column :government_school_districts, :ses_allocation_fy2010

    remove_column :government_school_districts, :at_risk_pupils_fy2011
    remove_column :government_school_districts, :poverty_pupils_fy2011
    remove_column :government_school_districts, :arra_allocation_fy2011
    remove_column :government_school_districts, :ses_allocation_fy2011
   end
end
