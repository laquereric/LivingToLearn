class FixClientHrs < ActiveRecord::Migration
  def self.up
    rename_column "person_clients", "phone1","phone_1"
    rename_column "person_clients", "phone2","phone_2"
    rename_column "person_clients", "phone3","phone_3"

=begin
    rename_column "person_employees", "phone1","phone_1"
    rename_column "person_employees", "phone2","phone_2"
    rename_column "person_employees", "phone3","phone_3"
    rename_column "person_employees", "w4","w_4"
    rename_column "person_clients", "address_line1", "address_line_1"
    rename_column "person_clients", "address_line2", "address_line_2"

    rename_column "person_clients", "fc_hrs9", "fc_hrs_9"
    rename_column "person_clients", "fc_hrs10", "fc_hrs_10"
    rename_column "person_clients", "fc_hrs11", "fc_hrs_11"
    rename_column "person_clients", "fc_hrs12", "fc_hrs_12"
    rename_column "person_clients", "fc_hrs1", "fc_hrs_1"
    rename_column "person_clients", "fc_hrs2", "fc_hrs_2"
    rename_column "person_clients", "fc_hrs3", "fc_hrs_3"
    rename_column "person_clients", "fc_hrs4", "fc_hrs_4"
    rename_column "person_clients", "fc_hrs5", "fc_hrs_5"
    rename_column "person_clients", "fc_hrs6", "fc_hrs_6"
    rename_column "person_clients", "fc_hrs7", "fc_hrs_7"
    rename_column "person_clients", "fc_hrs8", "fc_hrs_8"

    rename_column "person_clients", "sc_hrs9", "sc_hrs_9"
    rename_column "person_clients", "sc_hrs10", "sc_hrs_10"
    rename_column "person_clients", "sc_hrs11", "sc_hrs_11"
    rename_column "person_clients", "sc_hrs12", "sc_hrs_12"
    rename_column "person_clients", "sc_hrs1", "sc_hrs_1"
    rename_column "person_clients", "sc_hrs2", "sc_hrs_2"
    rename_column "person_clients", "sc_hrs3", "sc_hrs_3"
    rename_column "person_clients", "sc_hrs4", "sc_hrs_4"
    rename_column "person_clients", "sc_hrs5", "sc_hrs_5"
    rename_column "person_clients", "sc_hrs6", "sc_hrs_6"
    rename_column "person_clients", "sc_hrs7", "sc_hrs_7"
    rename_column "person_clients", "sc_hrs8", "sc_hrs_8"
=end
  end

  def self.down
  end
end
