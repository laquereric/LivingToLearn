class LinkTimeLogActivityUser < ActiveRecord::Migration

  def self.up

    remove_column "activities", "user_email"
    add_column "activities", "user_id", :integer

    remove_column "time_logs", "user_email"
    add_column "time_logs", "user_id", :integer

    add_column "time_logs", "activity_id", :integer
    remove_column "time_logs", "activity"

  end

  def self.down

    add_column "activities", "user_email", :integer
    remove_column "activities", "user_id"

    add_column "time_logs", "user_email", :integer
    remove_column "time_logs", "user_id"

    remove_column "time_logs", "activity_id"
    add_column "time_logs", "activity",:string

 end

end
