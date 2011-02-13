# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110210221252) do

  create_table "appointments", :force => true do |t|
    t.integer  "appointable_id"
    t.string   "loc"
    t.string   "day_of_week"
    t.integer  "hour"
    t.integer  "minute"
    t.string   "am_pm"
    t.datetime "actual"
    t.boolean  "tentative"
    t.text     "notes"
    t.string   "appointable_type"
    t.string   "duration"
  end

  create_table "contract_individuals", :force => true do |t|
    t.integer  "client_id"
    t.string   "grade"
    t.text     "client_first_name"
    t.text     "client_last_name"
    t.datetime "first_weekly_time"
    t.string   "first_weekly_place"
    t.datetime "second_weekly_time"
    t.string   "second_weekly_place"
    t.datetime "third_weekly_time"
    t.string   "third_weekly_place"
    t.datetime "fourth_weekly_time"
    t.string   "fourth_weekly_place"
    t.datetime "fifth_weekly_time"
    t.string   "fifth_weekly_place"
    t.datetime "sixth_weekly_time"
    t.string   "sixth_weekly_place"
    t.datetime "seventh_weekly_time"
    t.string   "seventh_weekly_place"
    t.decimal  "starting_date"
    t.decimal  "rate",                 :precision => 8, :scale => 2
  end

  create_table "contract_school_districts", :force => true do |t|
    t.integer "school_district_id"
    t.date    "date"
    t.decimal "rate",               :precision => 8, :scale => 2
    t.decimal "per_pupil_amount",   :precision => 8, :scale => 2
    t.string  "master_sub"
    t.string  "name"
  end

  create_table "doc_bases", :force => true do |t|
    t.string "filename"
    t.text   "meta"
  end

  create_table "document_pdfs", :force => true do |t|
    t.integer "entity_id"
    t.text    "tags"
    t.string  "filename"
  end

  create_table "education_events", :force => true do |t|
    t.string  "client_id"
    t.string  "first_name"
    t.string  "last_name"
    t.string  "date"
    t.string  "event"
    t.string  "result"
    t.string  "note"
    t.integer "order"
  end

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

  create_table "invoice_school_districts", :force => true do |t|
    t.integer "district_code"
    t.integer "contract_date"
    t.integer "client_id"
    t.string  "school"
    t.string  "student_first_name"
    t.string  "student_last_name"
    t.string  "district_name"
    t.string  "district_city"
    t.string  "district_state"
    t.string  "district_zip"
    t.string  "director_name"
    t.string  "invoice_number"
    t.date    "invoice_date"
    t.decimal "testing_fee",         :precision => 8, :scale => 2
    t.decimal "registration_fee",    :precision => 8, :scale => 2
    t.string  "fc_name"
    t.decimal "fc_rate",             :precision => 8, :scale => 2
    t.decimal "fc_hours",            :precision => 8, :scale => 2
    t.decimal "fc_amount",           :precision => 8, :scale => 2
    t.string  "sc_name"
    t.decimal "sc_rate",             :precision => 8, :scale => 2
    t.decimal "sc_hours",            :precision => 8, :scale => 2
    t.decimal "sc_amount",           :precision => 8, :scale => 2
    t.decimal "total_amount",        :precision => 8, :scale => 2
    t.decimal "hours_in_program",    :precision => 8, :scale => 2
    t.decimal "per_pupil_amount",    :precision => 8, :scale => 2
    t.boolean "second_invoice_line"
    t.date    "period_start"
    t.date    "period_end"
  end

  create_table "invoices", :force => true do |t|
    t.integer "contract_id"
    t.decimal "hours",       :precision => 8, :scale => 2
    t.integer "month"
    t.integer "year"
    t.decimal "amount",      :precision => 8, :scale => 2
  end

  create_table "locations", :force => true do |t|
    t.string  "address_line1"
    t.string  "address_line2"
    t.string  "zip"
    t.string  "zip4"
    t.integer "neighborhood_id"
    t.integer "city_id"
    t.integer "township_id"
    t.integer "school_district_id"
    t.integer "county_id"
    t.integer "state_id"
    t.integer "country_id"
    t.integer "detail_id"
    t.string  "detail_type"
    t.string  "entity_id"
    t.string  "city"
    t.string  "state"
  end

  create_table "notes", :force => true do |t|
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "entity_id"
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

  create_table "person_clients", :force => true do |t|
    t.string "contracted_hours"
    t.string "parent_xx_prefix"
    t.string "sc_hrs_7"
    t.string "second_contract"
    t.string "sc_hrs_12"
    t.string "middle_name"
    t.string "select"
    t.string "fc_hrs_2"
    t.string "sc_hrs_11"
    t.string "fc_hrs_1"
    t.string "last_paid_hour"
    t.string "fc_hrs_5"
    t.string "to_do"
    t.string "give_invoice"
    t.string "fc_hrs_10"
    t.string "school_district"
    t.string "representatives"
    t.string "zip"
    t.string "parent_xx_middle_name"
    t.string "school"
    t.string "active"
    t.string "phone_3"
    t.string "contract_hrs_per_week"
    t.string "sc_hrs_2"
    t.string "last_contract_hour"
    t.string "parent_xy_first_name"
    t.string "prefix"
    t.string "prepaid"
    t.string "phone_2"
    t.string "closed_end"
    t.string "fc_hrs_12"
    t.string "parent_xy_last_name"
    t.string "origin"
    t.string "state"
    t.string "parent_xy_suffix"
    t.string "city"
    t.string "fc_hrs_3"
    t.string "direct"
    t.string "sc_hrs_10"
    t.string "sc_hrs_9"
    t.string "address_line_2"
    t.string "email"
    t.string "parent_xx_suffix"
    t.string "status"
    t.string "parent_xx_last_name"
    t.string "last_consumed_hour"
    t.string "location"
    t.string "prev_contract_end_hour"
    t.string "phone_1"
    t.string "sc_hrs_3"
    t.string "suffix"
    t.string "dob"
    t.string "parent_xy_prefix"
    t.string "client_id"
    t.string "fc_hrs_6"
    t.string "fc_hrs_9"
    t.string "last_name"
    t.string "sc_hrs_8"
    t.string "fc_hrs_11"
    t.string "address_line_1"
    t.string "grade"
    t.string "sc_hrs_6"
    t.string "sc_hrs_4"
    t.string "parent_xy_middle_name"
    t.string "first_name"
    t.string "program_s"
    t.string "first_contract"
    t.string "fc_hrs_4"
    t.string "result"
    t.string "parent_xx_first_name"
    t.string "sc_hrs_1"
    t.string "fc_hrs_8"
    t.string "fc_hrs_7"
    t.string "last_attended_date"
    t.string "sc_hrs_5"
    t.string "sched_a"
    t.string "sched_b"
    t.string "sched_c"
    t.string "sched_d"
    t.string "sched_e"
    t.string "sched_f"
    t.string "sched_g"
    t.string "dur_a"
    t.string "dur_b"
    t.string "dur_c"
    t.string "dur_d"
    t.string "dur_e"
    t.string "dur_f"
    t.string "dur_g"
    t.string "primary_tutor"
    t.string "materials_only"
    t.string "map_spring"
    t.string "cat_5_vocabulary"
    t.string "cat_5_comprehension"
    t.string "cat_5_grammar"
    t.string "cat_5_punctuation"
  end

  create_table "person_employees", :force => true do |t|
    t.string "select"
    t.string "to_do"
    t.string "payroll_number"
    t.string "parent_payroll_number"
    t.string "prefix"
    t.string "first_name"
    t.string "nickname"
    t.string "middle_name"
    t.string "last_name"
    t.string "suffix"
    t.string "extension"
    t.string "title"
    t.string "home_email"
    t.string "address"
    t.string "email"
    t.string "phone_1"
    t.string "phone_2"
    t.string "phone_3"
    t.string "w_4"
    t.string "nj_tax"
    t.string "nj_criminal"
    t.string "sched_a"
    t.string "sched_b"
    t.string "sched_c"
    t.string "sched_d"
    t.string "sched_e"
    t.string "sched_f"
    t.string "sched_g"
    t.string "dur_a"
    t.string "dur_b"
    t.string "dur_c"
    t.string "dur_d"
    t.string "dur_e"
    t.string "dur_f"
    t.string "dur_g"
    t.string "school_district_employer"
    t.string "records_only"
    t.string "lump_sum"
    t.string "sched_h"
    t.string "dur_h"
    t.string "sched_i"
    t.string "dur_i"
  end

  create_table "person_parent_potential_payer", :force => true do |t|
    t.integer "entity_id"
    t.integer "prospect_id"
    t.string  "source"
    t.integer "government_school_entity_id"
    t.integer "government_school_district_entity_id"
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

  create_table "spreadsheet__tutoring_club__service_locations", :force => true do |t|
    t.string "location_id"
    t.string "name"
    t.string "address_line_1"
    t.string "address_line_2"
    t.string "city"
    t.string "state"
    t.string "zip"
  end

end
