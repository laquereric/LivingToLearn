class AdFulCodeFieldToCpi < ActiveRecord::Migration
  def self.up
    add_column "curriculum_cumulative_progress_indicators", :full_code, :string
  end

  def self.down
    remove_column "curriculum_cumulative_progress_indicators", :full_code
  end
end
