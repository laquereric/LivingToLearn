class Government::SchoolDistrict < Government::GovernmentDetail

  set_table_name :government_school_districts
  belongs_to :county_entity, :class_name => "Entity", :foreign_key => :government_county_id
  belongs_to :state_entity, :class_name => "Entity", :foreign_key => :government_state_id
  belongs_to :country_entity, :class_name => "Entity", :foreign_key => :government_country_id

  has_many :person_school_district_administrator_details,
    :class_name => "Person::SchoolDistrictAdministrator",
    :foreign_key => :government_school_district_detail_id

#############
# Files
#############
  def local_directory
    ENV['ARCHIVED_COMMUNICATIONS_DIR']
  end
  end

  def google_base_folder
    File.join( "TutoringClub" , "Data" , "Government_SchoolDistricts")
  end

  def google_foldername
    File.join( self.google_base_folder,"#{self.district_code}__#{name}")
  end


#  has_many :organization_non_profit_details,
#    :class_name => "Organization::NonProfit",
#    :foreign_key => :government_school_district_detail_id

##############
#
###############
  def code_name
    "#{self.government_district_code}__#{self.name}"
  end

  def self.id_from_code_name(cn)
    cn.split('__')[0]
  end

  def self.for_code_name(cn)
    return self.find_by_government_district_code( self.id_from_code_name(cn) )
  end

################
#
################
  def store_clients_by_school()
    lines = []
    ts= Time.now.to_s.gsub(' ','_')
    Dir.mkdir(self.directory) if !File.exists?(self.directory)
    report_file = File.join(self.directory,"clients_by_school_as_of_#{ts}")
    status= "Stored Report to #{report_file}"
    lines << status
    lines<< " "
    lines= self.clients_by_school(lines)
    File.open(report_file,'w+') do |file|
      lines.flatten.each{ |line|
        file.puts line
       }
    end
    return status
  end

#################
#
#################
  def self.each_district_with_ses_contract(&block)
    [5820,5860,3280,2990,1940,390,5820,1730].each{ |sd_id|
      yield( Government::SchoolDistrict.find_by_government_district_code(sd_id) )
    }
  end

  def clients_by_school(lines=[])
    lines<< "As of #{Date.today} #{Time.now}"
    lines<< "Clients in School District #{self.code_name} By School:"
    lines<< " "
    results= Person::Client.by_school_hash{ |client|
      (client[:school_district] == self.code_name)
    }
    Person::Client.by_school_report(results) { |line|
      lines<< line if line
    }
    return lines
  end

  def self.full_name_pretty(entity)
    "#{self.code_name} School District"
  end

  def self.name_pretty(entity)
    entity.name.split('_').map{ |n| n.capitalize}.join(' ')
  end

#########

  def self.at_cursor
    cursor_file= File.open(self.cursor_filename, 'r')
    text= cursor_file.read
    hash= YAML.load(text)
    self.find_by_district_code( hash[:district_code] )
  end

  def self.cursor_filename
    File.join( RAILS_ROOT, 'cursors','Government_SchoolDistrict' )
  end

  def set_cursor
    text = {:district_code => self.district_code}.to_yaml
    File.open(self.class.cursor_filename, 'w') { |f|
      f.write(text)
    }
  end

###########

  def history_total_funded_pupils_fy2010
    at_risk_pupils_fy2010 + poverty_pupils_fy2010
  end

  def history_total_allocation_fy2010
    arra_allocation_fy2010 + ses_allocation_fy2010
  end

  def history_per_pupil_allocation_fy2010
     format('%.0f',total_allocation_fy2010 / total_funded_pupils_fy2010)
  end

  def history_total_allocation_fy2011
    arra_allocation_fy2011 + ses_allocation_fy2010
  end

  def total_funded_pupils_fy2011
    at_risk_pupils_fy2011 + poverty_pupils_fy2011
  end

  def per_pupil_allocation_fy2011
    format('%.0f',ses_allocation_fy2011.to_f / total_funded_pupils_fy2011.to_f )
  end

  def after_school_hours
    format('%.0f', per_pupil_allocation_fy2011.to_f / 43.67)
  end

  def after_school_weeks
     format('%.0f', after_school_hours.to_f / 2 )
  end

  def at_home_hours
     format('%.0f', per_pupil_allocation_fy2011.to_f / 81.88 )
  end

  def at_home_weeks
     format('%.0f',  at_home_hours.to_f / 2 )
  end

###########################################
#
###########################################


  def self.parse_nj_address( line, address)
    if line.match(%r/\A\d/) or line.match(%r/\ PLACE/)  or line.match(%r/\APO /)  or line.match(%r/\AP.O./) or line.match(%r/ Lane/) or line.match(%r/ LANE/)  or line.match(%r/Blvd./) or line.match(%r/DR/)  or line.match(%r/RD/) or line.match(%r/ Drive/) or line.match(%r/ Parkway/) or line.match(%r/ Way/) or line.match(%r/ Road /) or line.match(%r/BLVD/)  or line.match(%r/Ave./) or line.match(%r/AVE/) or line.match(%r/Boulevard/) or line.match(%r/ST/)  or line.match(%r/Street/) or line.match(%r/Avenue/) or line.match(%r/ and /)
      address = line.strip
    end
    return address
  end

  def self.parse_nj_cityzip( line, city, zip)
    m = line.match(%r/(.*),(.*)/)
          if m
            city_state = m[1].strip
            city = if city_state.split(' ').length == 2 and city_state.split(' ')[-2] == 'NJ'
              city_state.split(' ')[0].join
            else
              city_state
            end
            state_zip = m[2].strip
            zip = state_zip.split(' ')[1]
          end
    return city , zip
  end

  def self.parse_nj_person( line, person_salutation , person_title )
    m = line.match(%r/(['Mr.'|'Dr.'|'Mrs.'|'Ms.']) (.*), (.*)/)
    if m
      person_salutation= line.split(' ')[0]
      person_name = m[2].strip
      tr= m[3].strip
      person_title = if tr.match(/\A[xX]/) then nil else tr end
      person_title = nil if person_title and person_title.length == 0
    end
    return  person_salutation , person_title
  end

  def self.parse_nj_tel( line, tel )
    tel= line if line.match(/\(\d\d\d\)\d\d\d-\d\d\d\d/)
    return tel
  end

  def self.parse_nj_sd( line, sd_name , sd_id )
    m = line.match(%r|(.*)\((\d\d\d\d)\)|)
    sd_name = m[1].strip.gsub(' ','_')
    sd_id = m[2].strip
    return sd_name,sd_id
  end

  def self.parse_name( line , m , name , id )
    m = line.match(%r|»(.*)\((.*)\)|)
    if m
      name = m[1].strip
      id = m[2].strip
    end
    return m, name, id
  end

  def self.parse_link( line , link )
    m = line.match(%r|http://(.*)|)
    if m
      link = "http://#{m[1]}"
    end
    return link
  end

  def self.parse_nj_file( filename  )
    file = File.open(File.join(RAILS_ROOT,'db/parse',filename))
    school_districts = []
    state = 'NJ'
    line_type = nil
    name = nil
    id = nil
    web_link = nil
    address = city = zip = nil
    tel = nil
    file.read.split("\n").each{ |line|
      m, t_name, t_id= Government::SchoolDistrict.parse_name( line, m, name , id )
      if m and !name.nil?
        sd= {
            :name => name,
            :id => id,
            :address => address,
            :city => city,
            :state => state,
            :zip => zip,
            :web_link => web_link #,
        }
        p sd
        school_districts<< sd
      end
      line_type = :start  if m
      name = t_name  if m
      id = t_id  if m
      line_type = case line_type
        when :l15 : :l16
        when :l14 : :l15
        when :l13 : :l14
        when :l12 : :l13
        when :l11 : :l12
        when :l10 : :l11
        when :l9 : :l10
        when :l8 : :l9
        when :l7 : :l8
        when :l6 : :l7
        when :l5 : :l6
        when :l4 : :l5
        when :l3 : :l4
        when :l2 : :l3
        when :sn : :l2
        when :start : :sn
      end
      case line_type
        when :l2
          address = self.parse_nj_address( line,address)
        when :l3 :
          address = self.parse_nj_address( line,address)
          city,zip = self.parse_nj_cityzip( line, city, zip)
        when :l4 :
          city,zip = self.parse_nj_cityzip( line, city, zip)
          web_link = self.parse_link( line, web_link )
        when :l5 :
          web_link = self.parse_link( line, web_link )
      end
    }
    sd= {
      :name => name,
      :id => id,
      :address => address,
      :city => city,
      :state => state,
      :zip => zip,
      :web_link => web_link
    }
    #p sd
    school_districts<< sd
    return school_districts
  end

  def self.cache_nj_file( filename )
    school_districts = parse_nj_file( filename )
    p "parsed from http://www.state.nj.us #{school_districts.length} school districts"
    return school_districts
  end

  def self.cache_key
    'nj_school_districts'
  end

  def self.cache_nj
    Rails.cache.delete(self.cache_key)
    #return
    school_district_hash= {}
    filename= "NJSchoolDistricts"
    cache_nj_file( filename ).each{ |sc| school_district_hash[ sc[:id] ] = sc }
    Rails.cache.fetch(self.cache_key) { school_district_hash }
  end

  def self.nj_cache
    Rails.cache.read(self.cache_key)
  end
 
end
