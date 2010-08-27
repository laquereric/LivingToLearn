class UpdateSchoolDistrictTable < ActiveRecord::Migration
  def self.up
    remove_column "government_school_districts", 'arra_allocation_fy2011'

    remove_column "government_school_districts", :ses_allocation_fy2010
    add_column "government_school_districts", :ses_allocation_fy2010, :integer

    remove_column "government_school_districts", :ses_allocation_fy2011
    add_column "government_school_districts", :ses_allocation_fy2011, :integer

    remove_column "government_school_districts", :arra_allocation_fy2010
    add_column "government_school_districts", :arra_allocation_fy2010, :integer
  end

  def self.down
    add_column "government_school_districts", 'arra_allocation_fy2011', :decimal
  end
end
