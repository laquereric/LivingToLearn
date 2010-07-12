class DetailsBelongtoEntity < ActiveRecord::Migration
  def self.up
    create_table "schools", :force => true do |t|
      t.references :government
      t.integer  "school_districti_id"
    end

    add_column "countries","government_id", :integer
    add_column "states","government_id", :integer
    add_column "counties","government_id", :integer
    add_column "school_districts", "government_id", :integer
    add_column "schools","government_id", :integer
    add_column "township_boros","government_id", :integer
    add_column "cities","government_id", :integer
    add_column "neighborhoods","government_id", :integer
  end

  def self.down
    drop_table "schools"
    remove_column "countries","government_id", :integer
    remove_column "states","government_id", :integer
    remove_column "counties","government_id", :integer
    remove_column "school_districts", "government_id", :integer
    remove_column "school","government_id", :integer
    remove_column "township_boros","government_id", :integer
    remove_column "cities","government_id", :integer
    remove_column "neighborhoods","government_id", :integer
   end
end
