class PotentialKvnSponsors < ActiveRecord::Migration
  def self.up

  create_table "spreadsheet__living_to_learn__potential_kvn_sponsors", :force => true do |t|
    t.string  :date_list_produced
    t.string  :record_obsolescence_date
    t.string  :source
    t.string  :company_name
    t.string  :address
    t.string  :city
    t.string  :state
    t.string  :zip_code
    t.string  :mailing_carrier_route
    t.string  :mailing_delivery_point_bar_code
    t.string  :location_address
    t.string  :location_address_city
    t.string  :location_address_state
    t.string  :location_address_zip
    t.string  :location_address_carrier_route
    t.string  :location_delivery_point_bar_code
    t.string  :location_carrier_route
    t.string  :county
    t.string  :phone_number
    t.string  :web_address
    t.string  :last_name
    t.string  :first_name
    t.string  :contact_title
    t.string  :contact_prof_title
    t.string  :contact_gender
    t.string  :actual_employee_size
    t.string  :employee_size_range
    t.string  :actual_sales_volume
    t.string  :sales_volume_range
    t.string  :primary_sic
    t.string  :primary_sic_description
    t.string  :secondary_sic_1
    t.string  :secondary_sic_description_1
    t.string  :secondary_sic_2
    t.string  :secondary_sic_description_2
    t.string  :credit_alpha_score
    t.string  :credit_numeric_score
    t.string  :headquarters_branch
    t.string  :year_1rst_appeared
    t.string  :office_size
    t.string  :square_footage
    t.string  :firm_individual
    t.string  :public_private_flag
    t.string  :pc_code
    t.string  :franchise_specialty_1
    t.string  :franchise_specialty_2
    t.string  :industry_specific_codes
    t.string  :adsize_in_yellow_pages
    t.string  :yp_spend
    t.string  :metro_area
    t.string  :infousa_id
  end
  end

  def self.down
    drop_table "spreadsheet__living_to_learn__potential_kvn_sponsors"
  end
end
