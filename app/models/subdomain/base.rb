require 'csv'
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

  def site_title_top_line
    "LivingToLearn"
  end

  def site_title_second_line
    "#{self.friendly_entity_name.titleize} Cares About Education!"
  end

#########
#
#########

  def friendly_type_name
    self.class.to_s.split('::')[-1].titleize
  end

  def friendly_entity_name
    self.name.titleize
  end

#########
# Utilties for Site Message Block
#########

  def site_type_title
    "Site for #{self.friendly_type_name}"
  end

  def site_location_lines
    "Located in #{self.muni.titleize} in #{self.county.titleize} County , #{self.state.capitalize}"
  end

  def site_contact_lines
    "Contact email: #{self.email}"
  end

##############
#
##############

###############
# Lower Level
###############

  def self.filename
    File.join(Rails.root,'data','sub_domains.csv')
  end

  def to_csv
    [ self.country, self.state, self.county, self.muni, self.type,
      self.name, self.theme, self.giveaway, self.prize, self.email ].join(',')
  end

  def self.clean_row(row)
    [0..header_symbols.length-1].each{ |col_num|
      row[col_num] = nil if !row[col_num].nil? and row[col_num].to_s.gsub(' ','').length == 0
    }
    return row
  end

  def self.all_to_csv
    self.all.map{ |r|
      r.to_csv
    }
  end

  def self.each_csv_row
    line_number = 0
    CSV::Reader.parse(File.open(self.filename, 'rb')) do |row|
      yield(line_number,self.clean_row(row) )
      line_number +=1
    end
  end

#######
#
#######

  def self.raw_csv_data
    rs = []
    self.each_csv_row{ |line_number,row|
      rs << row
    }
    return rs
  end

#######
#
#######

  def self.header_list
    strings = <<-eos
    Country
    State
    County
    Muni
    Type
    Name
    Theme
    Giveaway
    Prize
    Email
    eos
    return strings.split("\n").map{ |st| st.strip }
  end

  def self.header_symbols
    self.header_list.map{|n| n.downcase.gsub(' ','_').to_sym}
  end

  def self.row_hash(row)
    h = {}
    (0..self.header_symbols.length-1).each{ |i|
      k = self.header_symbols[i]
      h[ k ] = row[i]
    }
    return h
  end

###########
#
###########

  def self.csv_data
    rs=[]
    self.each_csv_row{ |line_number,row|
      next if line_number == 0
      rs<< row_hash(row)
    }
    return rs
  end

  def self.purge
    self.delete_all
  end

###########
#
###########

  def self.load_from_data_file
    rcd = self.raw_csv_data
    rcd.each_index{ |i|
      next if i == 0
      rh = self.row_hash(rcd[i])
      cls = rh[:type].constantize
      obj = cls.create(rh)
      p "Added #{obj.name}"
    }
  end

  def self.replace_with_data_file
    self.delete_all
    self.load_from_data_file
  end

  def self.all_to_data_file
    File.open(self.filename,'w'){ |f|
      f.puts( self.header_list.join(',') )
      self.all_to_csv.each{ |l|
        f.puts(l)
      }
    }
  end

end
