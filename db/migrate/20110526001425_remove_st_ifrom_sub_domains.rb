class RemoveStIfromSubDomains < ActiveRecord::Migration
  def self.up
    add_column :subdomain_base , :entity_type, :string
    Subdomain::Base.all.each{ |r| r.entity_type=r.type.to_s;r.save }
    remove_column :subdomain_base , :type
  end

  def self.down
    add_column :subdomain_base , :type
    Subdomain::Base.all.each{ |r| r.type=r.entity_type.to_s;r.save }
    remove_column :subdomain_base , :entity_type
  end
end
