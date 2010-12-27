class SdInvoice < ActiveRecord::Migration
  def self.up

    drop_table :contract_school_districts

    create_table "contract_school_districts", :force => true do |t|
      t.integer "school_district_id"
      t.date "date"
      t.decimal "rate",   :precision => 8, :scale => 2
      t.decimal "per_pupil_amount", :precision => 8, :scale => 2
      t.string "master_sub"
      t.string "name"
    end

    create_table "invoice_school_districts", :force => true do |t|

      t.integer "school_district_id"
      t.integer "contract_school_district_id"
      t.string  "school"

      t.string "student_first_name"
      t.string "student_last_name"
      t.string "district_name"
      t.string "district_city"
      t.string "district_state"
      t.string "district_zip"

      t.string "director_name"

      t.string "invoice_number"
      t.date  "invoice_date"

      t.decimal "testing_fee",   :precision => 8, :scale => 2
      t.decimal "registration_fee",   :precision => 8, :scale => 2

      t.string "fc_name"
      t.decimal "fc_rate",   :precision => 8, :scale => 2
      t.decimal "fc_hours",   :precision => 8, :scale => 2
      t.decimal "fc_amount",   :precision => 8, :scale => 2

      t.string "sc_name"
      t.decimal "sc_rate",   :precision => 8, :scale => 2
      t.decimal "sc_hours",   :precision => 8, :scale => 2
      t.decimal "sc_amount",   :precision => 8, :scale => 2
      
      t.decimal "hours_in_program",   :precision => 8, :scale => 2
      t.decimal "per_pupil_amount",   :precision => 8, :scale => 2
    end
  end

  def self.down
    drop_table "invoice_school_districts"
  end
end
