class PersonEmployee < ActiveRecord::Migration
  def self.up
    create_table "person_employees", :force => true do |t|
      t.string   :select
      t.string   :to_do
      t.string   :payroll_number
      t.string   :parent_payroll_number
      t.string   :prefix
      t.string   :first_name
      t.string   :nickname
      t.string   :middle_name
      t.string   :last_name
      t.string   :suffix
      t.string   :extension
      t.string   :title
      t.string   :home_email
      t.string   :address
      t.string   :email
      t.string   :phone1
      t.string   :phone2
      t.string   :phone3
      t.string   :w4
      t.string   :nj_tax
      t.string   :nj_criminal
    end
  end

  def self.down
    drop_table "person_employees"
  end
end
