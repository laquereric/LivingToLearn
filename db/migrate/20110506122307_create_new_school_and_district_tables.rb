class CreateNewSchoolAndDistrictTables < ActiveRecord::Migration
  def self.up
  create_table "government_school_district_kvns", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string :code
    t.string :name
    t.string :nickname
    t.string :chief_school_administrator
    t.string :phone_numbers
    t.string :chief_administrator_email
    t.string :web
    t.string :address_1
    t.string :address_2
    t.string :city
    t.string :state
    t.string :zip
    t.string :chief_secretary
    t.string :chief_secretary_phone
    t.text :notes

  end

  create_table "government_school_k6s", :force => true do |t|
    t.text :notes
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer :government_district_id
    t.text :district_code
    t.text :school_code
    t.text :grades
    t.text :name
    t.text :nickname
    t.text :school_address
    t.text :school_city
    t.text :school_state
    t.text :school_zip
    t.text :township
    t.text :school_web_site
    t.text :principal_prefix
    t.text :principal_first_name
    t.text :principal_last_name
    t.text :principal_phone_number
    t.text :principal_email
    t.text :principal_notes
    t.text :pto_contact_a_prefix
    t.text :pto_contact_a_first_name
    t.text :pto_contact_a_last_name
    t.text :pto_contact_a_phone_number
    t.text :pto_contact_a_email
    t.text :pto_contact_a_notes
    t.text :pto_contact_b_prefix
    t.text :pto_contact_b_first_name
    t.text :pto_contact_b_last_name
    t.text :pto_contact_b_phone_number
    t.text :pto_contact_b_email
    t.text :pto_contact_b_notes
    t.text :pto_notes
    t.text :pto_web_site
    t.text :num_of_papers_distributed_per_school
    t.text :total_num_of_papers_distributed_per_township
    t.text :where_papers_were_delivered
  end

  end

  def self.down
    drop_table "government_school_district_kvns"
    drop_table "government_school_k6s"
  end
end
