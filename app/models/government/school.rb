class Government::School < Government::GovernmentDetail

  set_table_name :government_schools
  has_many :person_pto_member_details, :class_name => "Person::PtoMember", :foreign_key => :government_school_detail_id

  def self.nj_types
    {
      :adult => "ADULT EDUCATION SCHOOL",
      :junior_high => "APPROVED JUNIOR HIGH SCHOOL",
      :vo_tech => "COUNTY VOC-TECH SCHOOL OR INSTITUTE",
      :elementary => "ELEMENTARY SCHOOL",
      :high_evening => "EVENING HIGH SCHOOL",
      :evening_foreign => "EVENING SCHOOL FOR FOREIGN BORN",
      :evening_votech => "EVENING VOC-TECH SCHOOL",
      :high_4y =>"FOUR-YEAR HIGH SCHOOL",
      :high_other => "HIGH SCHOOL-OTHER THAN LISTED ABOVE",
      :kindergarten => "KINDERGARTEN SCHOOL",
      :middle =>"MIDDLE SCHOOL",
      :nursery => "NURSERY/PRESCHOOL",
      :high_6y => "SIX-YEAR HIGH SCHOOL",
      :spec_elem_sec => "SPECIAL ELEM/SEC SCHOOL FOR HANDICAPPED",
      :spec_elem => "SPECIAL ELEMENTARY SCHOOL FOR HANDICAPPED",
      :spec_sec =>"SPECIAL SECONDARY SCHOOL FOR HANDICAPPED",
      :s3y =>"THREE-YEAR SCHOOL",
    }
  end

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
    m = line.match(%r|»(.*)\((\d\d-\d\d\d\d-\d\d\d)\)|)
    if m
      name = m[1].strip
      id = m[2].strip
    end
    return m, name, id
  end

  def self.parse_nj_file( filename  )
    file = File.open(File.join(RAILS_ROOT,'db/parse',filename))
    #file = File.open(File.join(RAILS_ROOT,'db/parse/NjElementarySchools'))
    schools = []
    state = 'NJ'
    line_type = nil
    name = nil
    id = sd_name = sd_id = nil
    person_salutation = person_name = person_title = nil
    address = city = zip = nil
    tel = nil
    file.read.split("\n").each{ |line|
      m, t_name, t_id= Government::School.parse_name( line, m, name , id )
      if m
        if !name.nil?
          schools<< {
            :name => name,
            :id => id,
            :sd_name => sd_name,
            :sd_id => sd_id,
            :person_salutation => person_salutation,
            :person_name => person_name,
            :person_title => person_title,
            :address => address,
            :city => city,
            :state => state,
            :zip => zip,
            :tel => tel
          }
        end
        name = t_name
        id = t_id
        sd_name = sd_id = nil
        person_salutation = person_name = person_title = nil
        address = city = zip = nil
        tel = nil
        line_type = :start
      end
      line_type = case line_type
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
          sd_name , sd_id = self.parse_nj_sd( line, sd_name , sd_id )
        when :l5 :
          person_salutation , person_title =
            self.parse_nj_person( line, person_salutation , person_title )
          address = self.parse_nj_address( line,address)
        when :l6 :
          city,zip = self.parse_nj_cityzip( line, city, zip)
          address = self.parse_nj_address( line,address)
        when :l7 :
          city,zip = self.parse_nj_cityzip( line, city, zip)
        when :l8 :
          city,zip = self.parse_nj_cityzip( line, city, zip)
          tel = self.parse_nj_tel( line, tel)
        when :l9 :
          tel = self.parse_nj_tel( line, tel)
      end
    }
          schools<< {
            :name => name,
            :id => id,
            :sd_name => sd_name,
            :sd_id => sd_id,
            :person_salutation => person_salutation,
            :person_name => person_name,
            :person_title => person_title,
            :address => address,
            :city => city,
            :state => state,
            :zip => zip,
            :tel => tel
          }
     return schools
  end

  def self.cache_nj_file( filename , sym )
    schools = parse_nj_file( filename ).map{ |sc|
      sc[:kind] = sym
      sc
    }
    p "parsed from http://www.state.nj.us #{schools.length} #{sym} schools"
    return schools
  end

  def self.cache_nj
    Rails.cache.delete('nj_schools')
    #Rails.cache.delete('nj_school_map')
    school_hash= {}
    self.nj_types.each_key{ |key|
      filename= "NJ#{key.to_s.camelcase}Schools"
      cache_nj_file( filename, key.to_s).each{ |sc| school_hash[ sc[:id] ]= sc }
    }
    Rails.cache.fetch('nj_schools') { school_hash }
    #Rails.cache.fetch('nj_district_school_map') { nj_district_school_map }
  end

  def self.nj_cache
    Rails.cache.read('nj_schools')
  end

  def self.nj_map_cache
     self.nj_district_school_map
     #Rails.cache.read('nj_district_school_map')
  end

  def self.nj_district_school_map
    map = {}
    self.nj_cache.each_value{ |sc|
p sc
      map[ sc[:sd_id] ] = [] if map[ sc[:sd_id] ].nil?
      map[ sc[:sd_id] ] << sc
    }
    return map
  end

end
