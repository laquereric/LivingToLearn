class Subdomain::Base < ActiveRecord::Base
  set_table_name :subdomain_base

  def self.create_mantua_test

    self.delete_all

    Muni.create({
      :email => 'laquereric@gmail.com',
      :muni => 'mantua',
      :name => 'mantua',
      :county => 'gloucester',
      :state => 'nj',
      :country => 'us'
    })
    County.create({
      :email => 'laquereric@gmail.com',
      :name => 'gloucester',
      :county => 'gloucester',
      :state => 'nj',
      :country => 'us'
    })
    State.create({
      :email => 'laquereric@gmail.com',
      :name => 'nj',
      :state => 'nj',
      :country => 'us'
    })
    Business.create({
      :name => 'tutoring_club',
      :email => 'laquereric@gmail.com',
      :muni => 'washington_twp',
      :county => 'gloucester',
      :state => 'nj',
      :country => 'us'
    })
  end

  def root_url(request)
    "#{self.path}.#{request.domain}:#{request.port}"
  end

  def self.valid_path(subdomain_path)
    valid = true
    subdomain_path.split('.').each{ |field|
      field_array = field.split('_')
      if !self.column_names.include?(field_array[0].to_s)
        valid = false
      end
    }
    return valid
  end

  def self.path_to_hash(subdomain_path)
    return nil if !self.valid_path(subdomain_path)
     #organization_name_tutoring_club.city_mantua.county_gloucester.state_nj.country_us
    subdomain_hash = {}
    subdomain_path.split('.').each{ |field|
      field_array = field.split('_')
      if self.column_names.include?(field_array[0].to_s)
        subdomain_hash[field_array[0].to_sym] = field_array[1..-1].join('_')
      else
        valid = false
      end
    }
    return subdomain_hash
  end

  def self.find_by_path(subdomain_path)
    return [] if !self.valid_path(subdomain_path)
    return self.find_by_hash( path_to_hash(subdomain_path) )
  end

  def self.is_path_to_site?(sub_domain_domain)
    sub_domain = sub_domain_domain[0]
    return false if !self.valid_path(sub_domain)
    subdomain_hash = self.path_to_hash(sub_domain)
    return false if subdomain_hash[:type].nil? or subdomain_hash[:name].nil?
    matches = self.find_by_hash(subdomain_hash)
    return ( matches.length == 1 )
  end

  def self.is_request_for_site?(request)
    return self.is_path_to_site?([request.subdomain , request.domain])
  end

  def self.clean_search_hash(search_hash)
    search_type = search_hash.delete('type')
    search_type[type] = "Subdomain::#{search_type}" if search_type
    return search_hash
  end

  def self.find_by_hash(search_hash)
    search_hash.keys.inject(scoped) do |combined_scope, attr|
      combined_scope.where("#{attr.to_s} LIKE ?", "%#{search_hash[attr]}%")
    end
  end

#########
#
#########

  def type_name
    self.class.to_s.split('::')[-1].downcase
  end

end
