class ChangeSiteRefCityToMuni < ActiveRecord::Migration
  def self.up
    rename_column "subdomain_base", :city , :muni
  end

  def self.down
    remove_column "subdomain_base", :muni , :city
  end
end
