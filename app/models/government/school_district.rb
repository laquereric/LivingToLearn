class Government::SchoolDistrict < Government::GovernmentDetail

  set_table_name :government_school_districts
  belongs_to :county_entity, :class_name => "Entity", :foreign_key => :government_county_id
  belongs_to :state_entity, :class_name => "Entity", :foreign_key => :government_state_id
  belongs_to :country_entity, :class_name => "Entity", :foreign_key => :government_country_id

  has_many :person_school_district_administrator_details,
    :class_name => "Person::SchoolDistrictAdministrator",
    :foreign_key => :government_school_district_detail_id

#################
#
#################
  def self.districts_with_ses_contracts
    ['7520','5820','5860','3280','2990','1940','0390','1730']
  end

  def self.each_district_with_ses_contract(&block)
    self.districts_with_ses_contracts.each{ |sd_id|
      yield( Government::SchoolDistrict.find_by_government_district_code(sd_id) )
    }
  end

#############
# Directory
#############

  def local_directory
    File.join(ENV['ARCHIVED_COMMUNICATIONS_DIR'],"#{self.code_name}")
  end

  def local_invoices_directory(month,year)
    File.join(self.local_directory,"invoices_#{month}_#{year}")
  end

  def local_status_directory()
    File.join(self.local_directory,"status")
  end

  def dropbox_directory
    File.join('/', 'Communications',"#{self.code_name}")
  end

  def dropbox_invoice_directory
    File.join( self.dropbox_directory,'invoices')
  end

  def google_base_folder
    File.join( "TutoringClub" , "Data" , "Government_SchoolDistricts")
  end

  def google_foldername
    File.join( self.google_base_folder,"#{self.district_code}__#{name}")
  end

#############
# Files
#############

  def self.timestamp
    Time.now.to_s.gsub('-','').gsub(':','_').gsub(' ','__')
  end

  def base(title='report')
    "#{self.code_name}_#{title}_as_of_#{self.class.timestamp}"
  end

#  has_many :organization_non_profit_details,
#    :class_name => "Organization::NonProfit",
#    :foreign_key => :government_school_district_detail_id

##############
#
###############
  def code_name
    "#{self.government_district_code.to_s}__#{self.name}"
  end

  def self.id_from_code_name(cn)
    return 0 if cn.nil?
    cn.split('__')[0].to_s
  end

  def same_sd?( code_name )
    return ( self.government_district_code.to_s == self.class.id_from_code_name( code_name ).to_s )
  end

  def self.for_code_name(cn)
    return self.find_by_government_district_code( self.id_from_code_name(cn) )
  end

################
#
################
  def store_clients_by_school(month,year,dropbox_session=nil)

    lines = []
    status_lines = []
    Dir.mkdir(self.local_directory) if !File.exists?(self.local_directory)
    Dir.mkdir(self.local_status_directory) if !File.exists?(self.local_status_directory)
    filename= File.join( self.local_status_directory, "as_of__#{self.class.timestamp}" )

    client_array= Person::Client.by_school_array{ |client|
      same_sd?( client[:school_district] )
      #(client[:school_district] == self.code_name)
    }

    Document::Reports::BySchool.print_by_school_report( self.code_name, self.local_directory , filename , client_array , month , year )

=begin
    if dropbox_session
      dropbox_session.upload self.local_report_file, self.dropbox_directory, {:mode=>:dropbox}
      db_status= "Stored Report to DropBox #{self.dropbox_directory}"
      status_lines << db_status
      lines << db_status
      lines<< " "
    end
=end

  end

  def store_invoice_csv( month , year , dropbox_session = nil )
    sd_total = 0.0
    Dir.mkdir(self.local_directory) if !File.exists?(self.local_directory)
    Dir.mkdir(self.local_invoices_directory(month,year)) if !File.exists?(self.local_invoices_directory(month,year))

    lines = []
    status_lines = []
    filename = File.join(self.local_invoices_directory(month,year),"spreadsheet_as_of__#{self.class.timestamp}.csv")
    File.open( filename,'w+') do |file|
        file.puts(Invoice::SchoolDistrict.csv_headers)
        self.each_invoice(month,year){ |client, invoice, description|
          sd_total += invoice.total_amount
          file.puts(invoice.csv_line)
          status_lines<< description
        }
    end
    status_lines << "sd_total= #{sd_total}"
    return status_lines
  end

  def invoice_date_field( month , year )
    "#{month}_#{year}"
  end

  def each_invoice( month , year , &block )

    client_array = Person::Client.with_logged_hours( self , month , year)
    client_array.each{ |client|
      invoice = Invoice::SchoolDistrict.create_for( client , month , year)
      description = "Invoice for #{client[:last_name]}_#{client[:first_name]}__Client_#{client[:client_id].to_i} in amount of #{invoice.total_amount} "
      yield( client , invoice , description )
    }
  end

  def store_invoices( month , year , dropbox_session = nil , &block )
    sd_total = 0.0
    Dir.mkdir(self.local_directory) if !File.exists?(self.local_directory)
    Dir.mkdir(self.local_invoices_directory(month,year)) if !File.exists?(self.local_invoices_directory(month,year))
    self.each_invoice(month,year){ |client,invoice, description|
      client_name_field = "#{client[:last_name]}_#{client[:first_name]}"
      client_id_field = "Client_#{client[:client_id].to_i}"
      dir_name = File.join(self.local_invoices_directory(month,year),"invoice__#{client_name_field}__#{client_id_field}__#{self.invoice_date_field(month,year)}")
      Dir.mkdir(dir_name) if !File.exists?(dir_name)
      base_name= 'invoice'
      pdf_filename = File.join(dir_name,"#{base_name}.pdf")
      Document::Invoices::SchoolDistrict.create_from_to( invoice , pdf_filename )

      sd_total += invoice.total_amount
      yield(description)
    }
    yield "sd_total= #{sd_total}"
  end

  def client_report_by_school( month, year , client_array , lines = [] )
    lines << "As of #{Date.today} #{Time.now}"
    lines << "Clients in School District #{self.code_name} By School:"
    lines << " "
    client = Person::Client.by_school_hash( client_array )
    Person::Client.by_school_report(client,month,year) { |line|
      lines << line if line
    }
    return lines
  end

  def csv_clients_by_school(month,year,client_array,lines=[])
#p client_array
    lines << Person::Client.csv_line_header
    client_array.each{ |client|
      #h = Person::Client.invoice_hash(month,year,client)
#p h
#      i = Invoice::SchoolDistrict.create(h)
#p i
      #next if h.nil?
      #line = Person::Client.csv_line( h )
      #lines<< line #if !line.nil?
    }
    return lines
  end

  def self.full_name_pretty( entity )
    "#{self.code_name} School District"
  end

  def self.name_pretty( entity )
    entity.name.split('_').map{ |n| n.capitalize}.join(' ')
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


  def self.parse_nj_address( line , address )
    if line.match(%r/\A\d/) or line.match(%r/\ PLACE/)  or line.match(%r/\APO /)  or line.match(%r/\AP.O./) or line.match(%r/ Lane/) or line.match(%r/ LANE/)  or line.match(%r/Blvd./) or line.match(%r/DR/)  or line.match(%r/RD/) or line.match(%r/ Drive/) or line.match(%r/ Parkway/) or line.match(%r/ Way/) or line.match(%r/ Road /) or line.match(%r/BLVD/)  or line.match(%r/Ave./) or line.match(%r/AVE/) or line.match(%r/Boulevard/) or line.match(%r/ST/)  or line.match(%r/Street/) or line.match(%r/Avenue/) or line.match(%r/ and /)
      address = line.strip
    end
    return address
  end

  def self.parse_nj_cityzip( line , city , zip )
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

  def self.parse_nj_person( line , person_salutation , person_title )
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

  def self.parse_nj_tel( line , tel )
    tel= line if line.match(/\(\d\d\d\)\d\d\d-\d\d\d\d/)
    return tel
  end

  def self.parse_nj_sd( line , sd_name , sd_id )
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

#################
# Reports
#################

  def self.status_report_for( month , year )
    dropbox_session = Service::Dropbox.get_session
    self.each_district_with_ses_contract{ |d|
p "SchoolDistrict #{d.code_name}"
      d.store_clients_by_school( month , year , dropbox_session ).each{ |l| p l }
    }
  end

  def self.invoice_csv_for( month , year )
    dropbox_session = Service::Dropbox.get_session
    Government::SchoolDistrict.each_district_with_ses_contract{ |d|
p "SchoolDistrict #{d.code_name}"
      d.store_invoice_csv( month , year , dropbox_session ).each{ |l|
        p l
      }
    }
  end

  def self.invoices_for( month , year )
    dropbox_session = Service::Dropbox.get_session
    Government::SchoolDistrict.each_district_with_ses_contract{ |d|
p "SchoolDistrict #{d.code_name}"
      d.store_invoices( month , year , dropbox_session ){ |l|
p l
      }
    }
  end

end
