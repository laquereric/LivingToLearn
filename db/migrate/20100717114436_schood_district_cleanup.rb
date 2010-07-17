class SchoodDistrictCleanup < ActiveRecord::Migration
  def self.up
    change_column "government_school_districts", "at_risk_pupils_fy2010", :integer
    change_column "government_school_districts", "poverty_pupils_fy2010", :integer
    change_column "government_school_districts", "at_risk_pupils_fy2011", :integer
    change_column "government_school_districts", "poverty_pupils_fy2011", :integer
  end

  def self.down
    change_column "government_school_districts", "at_risk_pupils_fy2010",:decimal,:precision => 8, :scale => 2
    change_column "government_school_districts", "poverty_pupils_fy2010",:decimal,:precision => 8, :scale => 2
    change_column "government_school_districts", "at_risk_pupils_fy2011",:decimal,:precision => 8, :scale => 2
    change_column "government_school_districts", "poverty_pupils_fy2011",:decimal,:precision => 8, :scale => 2
  end
end
