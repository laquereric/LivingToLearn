class Invoice < ActiveRecord::Migration

  def self.up

    create_table "invoices", :force => true do |t|
      t.integer "contract_id"
      t.decimal :hours, :precision => 8, :scale => 2
      t.integer "month"
      t.integer "year"
      t.decimal :amount, :precision => 8, :scale => 2
    end

    create_table "contract_school_districts", :force => true do |t|
      t.integer "school_district_id"
      t.integer "number"
      t.string "school"
      t.string "school_city"
      t.string "school_state"
      t.string "school_zip"
      t.decimal :hours_in_program, :precision => 8, :scale => 2
      t.decimal :per_pupil_amount, :precision => 8, :scale => 2
    end
    
    create_table "contract_individuals", :force => true do |t|
      t.integer "client_id"
      t.integer "ses_school_district_id"
      t.integer "ses_contract_number"
      t.string "grade"
      t.text "client_first_name"
      t.text "client_last_name"

      t.datetime :first_weekly_time
      t.string :first_weekly_place
      t.datetime :second_weekly_time
      t.string :second_weekly_place
      t.datetime :third_weekly_time
      t.string :third_weekly_place
      t.datetime :fourth_weekly_time
      t.string :fourth_weekly_place
      t.datetime :fifth_weekly_time
      t.string :fifth_weekly_place
      t.datetime :sixth_weekly_time
      t.string :sixth_weekly_place
      t.datetime :seventh_weekly_time
      t.string :seventh_weekly_place

      t.decimal :starting_date
      t.decimal :rate, :precision => 8, :scale => 2
    end
  end

  def self.down
    drop_table "contract_school_districts"
    drop_table "contract_individuals"
    #drop_table "contract"
    drop_table "invoices"
  end

end
