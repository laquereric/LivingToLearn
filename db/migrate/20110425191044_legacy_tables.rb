class LegacyTables < ActiveRecord::Migration
  def self.up

  create_table "entities", :force => true do |t|
    t.string   "type"
    t.string   "prefix"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "suffix"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "web_address"
    t.string   "wikipedia_address"
  end

  create_table "entity_details", :force => true do |t|
    t.string  "type"
    t.integer "entity_id"
    t.integer "detail_id"
    t.string  "detail_type"
  end

  create_table "government_cities", :force => true do |t|
    t.integer "township_boro_id"
    t.integer "entity_id"
  end

  create_table "government_counties", :force => true do |t|
    t.integer "state_id"
    t.integer "entity_id"
    t.integer "government_state_id"
    t.integer "government_country_id"
  end

  create_table "government_countries", :force => true do |t|
    t.integer "entity_id"
  end

  create_table "government_neighborhoods", :force => true do |t|
    t.integer "city_id"
    t.integer "entity_id"
  end

  create_table "government_school_districts", :force => true do |t|
    t.integer "government_county_id"
    t.integer "entity_id"
    t.integer "government_country_id"
    t.integer "government_state_id"
    t.integer "district_code"
    t.integer "at_risk_pupils_fy2010"
    t.integer "poverty_pupils_fy2010"
    t.integer "at_risk_pupils_fy2011"
    t.integer "poverty_pupils_fy2011"
    t.integer "ses_allocation_fy2010"
    t.integer "ses_allocation_fy2011"
    t.integer "arra_allocation_fy2010"
    t.string  "status"
    t.string  "government_district_code"
  end

  create_table "government_schools", :force => true do |t|
    t.integer "school_district_id"
    t.integer "entity_id"
  end

  create_table "government_states", :force => true do |t|
    t.integer "country_id"
    t.integer "entity_id"
    t.integer "government_country_id"
  end

  create_table "government_township_boros", :force => true do |t|
    t.integer "county_id"
    t.integer "entity_id"
  end

  create_table "organization_churches", :force => true do |t|
    t.integer "entity_id"
  end

  create_table "organization_partners", :force => true do |t|
    t.integer "entity_id"
    t.string  "type"
  end

  create_table "organization_ses_provider", :force => true do |t|
    t.integer "ses_provider_id"
    t.integer "entity_id"
    t.text    "contact"
    t.text    "areas_served"
    t.text    "services"
    t.text    "qualifications"
  end

  create_table "person_church_leaders", :force => true do |t|
    t.integer "entity_id"
    t.integer "organization_church_detail_id"
  end

  create_table "person_partners", :force => true do |t|
    t.integer "entity_id"
    t.string  "type"
  end

  create_table "person_pto_member", :force => true do |t|
    t.integer "entity_id"
    t.integer "government_school_detail_id"
  end

  create_table "person_school_district_administrator", :force => true do |t|
    t.integer "entity_id"
    t.integer "government_school_district_detail_id"
  end

  create_table "spreadsheet__living_to_learn__municipalities", :force => true do |t|
    t.string "county"
    t.string "municipality"
    t.string "township_borough_city"
  end

  create_table "spreadsheet__living_to_learn__objectives_benefits_features", :force => true do |t|
    t.string "name"
    t.string "objective"
    t.string "benefit"
    t.string "feature"
  end

  create_table "spreadsheet__living_to_learn__organization_members", :force => true do |t|
    t.string "organization_name"
    t.string "address_line_1"
    t.string "address_line_2"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "website"
    t.string "phone"
    t.string "contact_first_name"
    t.string "contact_middle_name"
    t.string "contact_last_name"
    t.string "contact_address_line_1"
    t.string "contact_address_line_2"
    t.string "contact_city"
    t.string "contact_state"
    t.string "contact_zip"
    t.string "contact_email"
    t.string "contact_cell_phone"
    t.string "contact_work_phone"
    t.string "organization_type"
  end

  create_table "spreadsheet__living_to_learn__organization_types", :force => true do |t|
    t.string "name"
    t.string "obf_1"
    t.string "obf_2"
    t.string "obf_3"
  end

  create_table "spreadsheet__living_to_learn__potential_kvn_sponsors", :force => true do |t|
    t.string "date_list_produced"
    t.string "record_obsolescence_date"
    t.string "source"
    t.string "company_name"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "zip_code"
    t.string "mailing_carrier_route"
    t.string "mailing_delivery_point_bar_code"
    t.string "location_address"
    t.string "location_address_city"
    t.string "location_address_state"
    t.string "location_address_zip"
    t.string "location_address_carrier_route"
    t.string "location_delivery_point_bar_code"
    t.string "location_carrier_route"
    t.string "county"
    t.string "phone_number"
    t.string "web_address"
    t.string "last_name"
    t.string "first_name"
    t.string "contact_title"
    t.string "contact_prof_title"
    t.string "contact_gender"
    t.string "actual_employee_size"
    t.string "employee_size_range"
    t.string "actual_sales_volume"
    t.string "sales_volume_range"
    t.string "primary_sic"
    t.string "primary_sic_description"
    t.string "secondary_sic_1"
    t.string "secondary_sic_description_1"
    t.string "secondary_sic_2"
    t.string "secondary_sic_description_2"
    t.string "credit_alpha_score"
    t.string "credit_numeric_score"
    t.string "headquarters_branch"
    t.string "year_1rst_appeared"
    t.string "office_size"
    t.string "square_footage"
    t.string "firm_individual"
    t.string "public_private_flag"
    t.string "pc_code"
    t.string "franchise_specialty_1"
    t.string "franchise_specialty_2"
    t.string "industry_specific_codes"
    t.string "adsize_in_yellow_pages"
    t.string "yp_spend"
    t.string "metro_area"
    t.string "infousa_id"
  end

  create_table "organization_churches", :force => true do |t|
    t.integer "entity_id"
  end

  create_table "organization_partners", :force => true do |t|
    t.integer "entity_id"
    t.string  "type"
  end

  create_table "organization_ses_provider", :force => true do |t|
    t.integer "ses_provider_id"
    t.integer "entity_id"
    t.text    "contact"
    t.text    "areas_served"
    t.text    "services"
    t.text    "qualifications"
   end

  end

  def self.down

  drop_table "entities"
  drop_table "entity_details"
  drop_table "government_cities"
  drop_table "government_counties"
  drop_table "government_countries"
  drop_table "government_neighborhoods"
  drop_table "government_school_districts"
  drop_table "government_schools"
  drop_table "government_states"
  drop_table "government_township_boros"
  drop_table "organization_churches"
  drop_table "organization_partners"
  drop_table "organization_ses_provider"
  drop_table "person_church_leaders"
  drop_table "person_partners"
  drop_table "person_pto_member"
  drop_table "person_school_district_administrator"
  drop_table "spreadsheet__living_to_learn__municipalities"
  drop_table "spreadsheet__living_to_learn__objectives_benefits_features"
  drop_table "spreadsheet__living_to_learn__organization_members"
  drop_table "spreadsheet__living_to_learn__organization_types"
  drop_table "spreadsheet__living_to_learn__potential_kvn_sponsors"
  drop_table "organization_churches"
  drop_table "organization_partners"
  drop_table "organization_ses_provider"

  end
end
