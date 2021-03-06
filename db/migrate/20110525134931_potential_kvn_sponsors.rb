class PotentialKvnSponsors < ActiveRecord::Migration
  def self.up

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

  end

  def self.down
    drop_table "potential_kvn_sponsors"
  end
end
