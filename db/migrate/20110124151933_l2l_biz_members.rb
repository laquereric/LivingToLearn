class L2lBizMembers < ActiveRecord::Migration
  def self.up

create_table "spreadsheet__living_to_learn__organization_members", :force => true do |t|
t.string   :organization_name
t.string   :address_line_1
t.string   :address_line_2
t.string   :city
t.string   :state
t.string   :zip
t.string   :website
t.string   :phone
t.string   :contact_first_name
t.string   :contact_middle_name
t.string   :contact_last_name
t.string   :contact_address_line_1
t.string   :contact_address_line_2
t.string   :contact_city
t.string   :contact_state
t.string   :contact_zip
t.string   :contact_email
t.string   :contact_cell_phone
t.string   :contact_work_phone
end

  end

  def self.down
    drop_table "spreadsheet__living_to_learn__business_members"
  end
end
