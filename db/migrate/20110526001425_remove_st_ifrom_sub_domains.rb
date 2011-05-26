class RemoveStIfromSubDomains < ActiveRecord::Migration
  def self.up
    add_column :subdomain_base , :entity_type, :string
    Subdomain.all.each{ |r|
      ta = r.type.to_s.split('::')
      ta[0]='Entity'
      r.entity_type = ta.join('::')
      r.save
p r
    }
    remove_column :subdomain_base , :type
  end

  def self.down

    add_column :subdomain_base , :type, :string
    Subdomain.all.each{ |r|
      ta = r.entity_type.to_s.split('::')
      ta[0]='Subdomain'
      r.type = ta.join('::')
      r.save
p r
    }
    remove_column :subdomain_base , :entity_type

  end
end
