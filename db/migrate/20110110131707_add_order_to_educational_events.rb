class AddOrderToEducationalEvents < ActiveRecord::Migration
  def self.up
    add_column "education_events", "order", :integer
  end

  def self.down
    remove_column "education_events", "order"
  end
end
