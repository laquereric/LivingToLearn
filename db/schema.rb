# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110625183931) do

  create_table "admins", :force => true do |t|
    t.string   "email",                                    :default => "", :null => false
    t.string   "encrypted_password",        :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                            :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "current_marketing_context"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  create_table "contexts", :force => true do |t|
    t.boolean  "at_registration"
    t.text     "user_email"
    t.text     "topic"
    t.text     "service"
    t.text     "marketing"
    t.text     "subdomain_path"
    t.text     "ref_type"
    t.text     "ref_field"
    t.text     "ref_value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "curriculum_content_areas", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "full_code"
    t.string   "by_end_of_grade"
  end

  create_table "curriculum_content_statements", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.text     "description"
    t.string   "by_end_of_grade"
    t.integer  "curriculum_strand_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "full_code"
  end

  create_table "curriculum_cumulative_progress_indicators", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.text     "description"
    t.string   "by_end_of_grade"
    t.integer  "curriculum_content_statement_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "full_code"
  end

  create_table "curriculum_items", :force => true do |t|
    t.string   "source_klass_name"
    t.string   "source_full_code"
    t.string   "target_node_klass_name"
    t.integer  "target_node_object_id"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "curriculum_map_arces", :force => true do |t|
    t.string   "secondary_curriculum_code"
    t.integer  "educational_resource_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "curriculum_roots", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "full_code"
    t.string   "by_end_of_grade"
  end

  create_table "curriculum_standards", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.text     "description"
    t.integer  "curriculum_content_area_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "full_code"
    t.string   "by_end_of_grade"
  end

  create_table "curriculum_strands", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.text     "description"
    t.integer  "curriculum_standard_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "split",                  :default => 0.0
    t.string   "full_code"
    t.string   "by_end_of_grade"
  end

  create_table "educational_resources", :force => true do |t|
    t.integer  "res_id"
    t.integer  "parent_res_id"
    t.text     "primary_curriculum_code"
    t.text     "kind"
    t.text     "isbn"
    t.text     "web"
    t.text     "filepath"
    t.text     "page"
    t.text     "reference"
    t.text     "description"
    t.float    "dist_down"
    t.float    "dist_right"
    t.float    "height"
    t.float    "width"
    t.datetime "created_at"
    t.datetime "updated_at"
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

  create_table "government_school_district_kvns", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "code"
    t.string   "name"
    t.string   "nickname"
    t.string   "chief_school_administrator"
    t.string   "phone_numbers"
    t.string   "chief_administrator_email"
    t.string   "web"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "chief_secretary"
    t.string   "chief_secretary_phone"
    t.text     "notes"
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

  create_table "government_school_k6s", :force => true do |t|
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "government_district_id"
    t.text     "district_code"
    t.text     "school_code"
    t.text     "grades"
    t.text     "name"
    t.text     "nickname"
    t.text     "school_address"
    t.text     "school_city"
    t.text     "school_state"
    t.text     "school_zip"
    t.text     "township"
    t.text     "school_web_site"
    t.text     "principal_prefix"
    t.text     "principal_first_name"
    t.text     "principal_last_name"
    t.text     "principal_phone_number"
    t.text     "principal_email"
    t.text     "principal_notes"
    t.text     "pto_contact_a_prefix"
    t.text     "pto_contact_a_first_name"
    t.text     "pto_contact_a_last_name"
    t.text     "pto_contact_a_phone_number"
    t.text     "pto_contact_a_email"
    t.text     "pto_contact_a_notes"
    t.text     "pto_contact_b_prefix"
    t.text     "pto_contact_b_first_name"
    t.text     "pto_contact_b_last_name"
    t.text     "pto_contact_b_phone_number"
    t.text     "pto_contact_b_email"
    t.text     "pto_contact_b_notes"
    t.text     "pto_notes"
    t.text     "pto_web_site"
    t.text     "num_of_papers_distributed_per_school"
    t.text     "total_num_of_papers_distributed_per_township"
    t.text     "where_papers_were_delivered"
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

  create_table "marketing_context_types", :force => true do |t|
    t.string  "name"
    t.string  "prompt"
    t.text    "service_type_list"
    t.integer "order"
    t.text    "message"
    t.string  "title"
  end

  create_table "marketing_contexts", :force => true do |t|
    t.string  "marketing_context_type_id"
    t.integer "user_id"
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

  create_table "potential_kvn_sponsors", :force => true do |t|
    t.string   "yp_spend"
    t.string   "year1rst_appeared"
    t.string   "contact_gender"
    t.string   "location_delivery_point_bar_code"
    t.string   "location_address_city"
    t.string   "city"
    t.string   "address"
    t.string   "category"
    t.string   "franchise_specialty1"
    t.string   "location_address_zip"
    t.string   "franchise_specialty2"
    t.string   "credit_alpha_score"
    t.string   "sales_volume_range"
    t.string   "location_carrier_route"
    t.string   "mailing_delivery_point_bar_code"
    t.string   "zip_code"
    t.string   "company_name"
    t.string   "notes"
    t.string   "primary_sic"
    t.string   "actual_employee_size"
    t.string   "location_address"
    t.string   "adsize_in_yellow_pages"
    t.string   "industry_specific_codes"
    t.string   "square_footage"
    t.string   "office_size"
    t.string   "credit_numeric_score"
    t.string   "primary_sic_description"
    t.string   "pc_code"
    t.string   "contact_title"
    t.string   "county"
    t.string   "mailing_carrier_route"
    t.string   "firm_individual"
    t.string   "headquarters_branch"
    t.string   "secondary_sic1"
    t.string   "contact_prof_title"
    t.string   "phone_number"
    t.string   "infousa_id"
    t.string   "secondary_sic2"
    t.string   "secondary_sic_description1"
    t.string   "employee_size_range"
    t.string   "last_name"
    t.string   "secondary_sic_description2"
    t.string   "actual_sales_volume"
    t.string   "location_address_state"
    t.string   "record_obsolescence_date"
    t.string   "web_address"
    t.string   "source"
    t.string   "date_list_produced"
    t.string   "metro_area"
    t.string   "public_private_flag"
    t.string   "email"
    t.string   "first_name"
    t.string   "state"
    t.string   "benefactor_potential"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "services", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "site_contents", :force => true do |t|
    t.text     "html"
    t.string   "type"
    t.text     "search_terms"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.string   "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
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

  create_table "subdomain_base", :force => true do |t|
    t.string   "country"
    t.string   "state"
    t.string   "county"
    t.string   "muni"
    t.string   "name"
    t.string   "theme"
    t.string   "giveaway"
    t.string   "prize"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ref_type"
    t.string   "ref_field"
    t.string   "ref_value"
    t.string   "entitytype"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                    :default => "", :null => false
    t.string   "encrypted_password",        :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                            :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "current_marketing_context"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.boolean  "admin"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
