class TutoringClubServiceLocations < ActiveRecord::Migration
  def self.up
create_table "spreadsheet__tutoring_club__service_locations", :force => true do |t|
t.string   :location_id
t.string   :name
t.string   :address_line_1
t.string   :address_line_2
t.string   :city
t.string   :state
t.string   :zip
end

  end

  def self.down
drop_table "spreadsheet__tutoring_club__service_locations"
  end
end
