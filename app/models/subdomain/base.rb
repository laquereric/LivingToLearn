class Subdomain::Base < ActiveRecord::Base
  set_table_name :subdomain_base

  def self.create_mantua_test
    self.delete_all
    self.create({
      :manager_email => 'laquereric@gmail.com',
      :city => 'mantua',
      :county => 'gloucester',
      :state => 'nj',
      :country => 'us'
    })
  end

  def path()
    fields = []
    fields << "city_#{self.city}"
    fields << "county_#{self.county}"
    fields << "state_#{self.state}"
    fields << "country_#{self.country}"
    return fields.join('.')
  end

  def self.find_by_hash(subdomain_hash)
    subdomain_hash.keys.inject(scoped) do |combined_scope, attr|
        combined_scope.where("#{attr.to_s} LIKE ?", "%#{subdomain_hash[attr]}%")
    end
  end

end
