class CreateAppointment < ActiveRecord::Migration
  def self.up

  create_table "appointments", :force => true do |t|
    t.integer :client_id
    t.string  :loc
    t.string :day_of_week
    t.integer :hour
    t.integer :minute
    t.string :am_pm
    t.datetime :actual
    t.boolean :tentative
    t.text :notes
  end

  end

  def self.down
    drop_table "appointments"
  end
end
