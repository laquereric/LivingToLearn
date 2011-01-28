class Person::Client < ActiveRecord::Base

  set_table_name ('person_clients')
  include Appointable

  def appointable_id
    self.client_id
  end

  def self.find_by_appointable_id(id)
    self.find_by_client_id(id)
  end

  def school_district_object
    Government::SchoolDistrict.for_code_name(self.school_district)
  end

  def self.all_for(school_district)
    self.all.select{ |client| school_district.same_sd?( client.school_district ) }
  end

  def self.store_row_hash(row_hash)
    self.create(row_hash)
  end

  def self.prepare_table_for_stores()
    self.delete_all
  end

  def self.csv_line(client,indent=0)
    l = ""
    l<< "#{ client[:result] }"
    return l
  end

  def self.each_client (&block)
    Spreadsheet::CurrentClients.each_client{ |client_o|
      yield( client_o )
    }
  end

  def self.binder_types
    [:revenue,:contract]
  end

##########################################
# View Helpers
##########################################

  def indent_string(indent=0)
    i = ""
    indent.times{ i<< ' ' }
    return i
  end

  def comlete_string( indent = 0 , hash = {} )
    hash[:indent_string] = indent_string( indent )
    return "#{hash[:indent_string]} #{hash[:prompt_string]} #{hash[:value_string]}"
  end


#################################################################################
  def self.csv_keys
    [:student_first_name,:student_last_name,:district_name,:government_district_code,:client_code,:period_month,:period_year,:invoice_date,:school,:district_city,:district_state,:district_zip,:fc_rate,:sc_rate,:fc_hours,:sc_hours,:fc_amount,:sc_amount,:amount,:per_pupil_amount,:hours_in_program]
  end

  def self.csv_line_header
    self.csv_keys.map{ |ky| ky.to_s }.join(',')
  end

  def self.csv_line(hash)
     self.csv_keys.map{ |ky| hash[ky].to_s }.join(',')
     #hash.each_value.map{ |vl| vl.to_s }.join(',')
  end

  def invoice_for(month,year)
    client = self
    r = Invoice::SchoolDistrict.new

    period = Period.this_month( Date.parse("#{month}\/01\/#{year}" ) )

    r[:period_start] = period.begin_time
    r[:period_end] = period.end_time

    r[:director_name] = 'Eric Laquer'

    r[:testing_fee] = 0
    r[:registration_fee] = 0
    r[:client_id] = client[:client_id].to_i
    r[:student_first_name] = client[:first_name]
    r[:student_last_name] = client[:last_name]

    r[:school] = client[:school]
    sd = Government::SchoolDistrict.for_code_name( client[:school_district] )
    Government::SchoolDistrict.nj_cache()

    sd_id = Government::SchoolDistrict.id_from_code_name( client[:school_district] )
    r[:district_code] = sd_id
    sd_rec = Government::SchoolDistrict.nj_cache[ sd_id ]
p "bad sd_id #{sd_id} from #{ client[:school_district] } " if sd_rec.nil?
    r[:district_name] = sd.name.gsub('_',' ')
    r[:district_city] = sd_rec[:city]
    r[:district_state] = sd_rec[:state]
    r[:district_zip] = sd_rec[:zip]

    r[:invoice_date] =  Date.today

    fc = Contract::SchoolDistrict.fc_for_sd(sd)

    r[:fc_name] = fc[:name]
    r[:sc_name] = nil

    r[:per_pupil_amount] = fc[:per_pupil_amount]
    r[:fc_hours] = fc_hours = client.fc_hours_in_period(month,year)

    r[:fc_rate] = fc_rate = fc[:rate]
    r[:fc_amount] = fc_amount = fc_hours * fc_rate

    r[:sc_name] = sc_name = nil
    r[:sc_amount] = sc_amount= 0
    r[:sc_hours] = sc_hours = 0
    r[:sc_rate] = sc_rate = 0

    if not(Contract::SchoolDistrict.has_two_contracts?(sd) or
      Contract::SchoolDistrict.has_master_slave_contracts?(sd) )
      r[:hours_in_program] = fc[:hours_in_program]
   else
      sc = Contract::SchoolDistrict.sc_for_sd(sd)
      r[:sc_name] = sc[:name]
      r[:sc_hours] = sc_hours = client.sc_hours_in_period(month,year)
      r[:sc_rate] = sc_rate = sc[:rate]
      r[:sc_amount] = sc_amount = sc_hours * sc_rate
    end

    if Contract::SchoolDistrict.has_two_contracts?(sd) and r[:sc_hours] > 0 then
      r[:fc_name]= r[:sc_name]
      r[:fc_hours] = r[:sc_hours]
      r[:fc_rate] = r[:sc_rate]
      r[:fc_amount] = r[:sc_amount]

      r[:per_pupil_amount] = sc[:per_pupil_amount]

      r[:sc_name] = nil
      r[:sc_hours] = 0
      r[:sc_rate] = 0
      r[:sc_amount] = 0
    end

    r[:second_invoice_line] = Contract::SchoolDistrict.second_invoice_line?(sd)

    if fc_hours == 0 and sc_hours == 0
      p "record wo hours! #{r.inspect}"
    end

    r[:total_amount] = fc_amount + sc_amount

    r[:invoice_number] = "SD#{r[:district_code]}_C#{r[:client_id]}_P#{year}_#{month}"

    return r
  end

  def total_hours_in_period( month , year )
    client = self
    return client.fc_hours_in_period(month,year) + client.sc_hours_in_period(month,year)
  end

  def self.clean_hours( raw )
    c =  case raw.class.to_s
      when 'String' : raw.to_i
      when 'Float' : raw
      when 'NilClass' : 0
    end
    return c
  end

  def fc_hours_in_period( month , year )
    client = self
    fc_hrs_field_sym = "fc_hrs_#{month}".to_sym
    raw = client[fc_hrs_field_sym]
    fc_hours = client.class.clean_hours(raw)
    return fc_hours
  end

  def sc_hours_in_period( month , year )
    client = self
    sc_hrs_field_sym = "sc_hrs_#{month}".to_sym
    raw = client[sc_hrs_field_sym]
    sc_hours = client.class.clean_hours(raw)
    return sc_hours
  end

  def self.by_school_array ( &block )
    rs=[]
    Person::Client.each_client{ |client|
      next if block_given? and !yield(client)
      rs<< client
    }
    return rs
  end

  def self.by_school_hash ( client_array )
      results= {}
      client_array.each{ |client|
        sd = Person::Client.school_district_sym(client)
        school = Person::Client.school_sym(client)
        result = Person::Client.clean_result(client)
        if results[sd].nil?
          results[sd] = {}
        end

        if results[sd][school].nil?
          results[sd][school] = { :other => [] }
        end

        if results[sd][school][result].nil?
          results[sd][school][result]=[]
        end
        results[sd][school][result] << client
      }
      return results
  end

  def self.result_types
    [:revenue,:contract,:test_done,:testing,:test_only,:more_info_required,:contract_dead,:ses_funds_gone,:no_ses_funds,:other]
  end

  def self.result_type_key
    {
       :revenue => "Hours have been logged",
       :contract => "Contract is in place but no hours were billed yet",
       :test_done => "Testing was done but no contract is in place",
       :testing => "Testing has begun",
       :test_only => "Testing to be done w/o contract",
       :more_info_required => "Cannot contact",
       :contract_dead => "Have given up.",
       :ses_funds_gone => "SES finds were used up.",
       :no_ses_funds => "There were no SES funds available",
       :other=>''
     }
  end

  def self.clean_result(client)
    result = client[:result].to_sym if client[:result]
    result = :other if !result_types.include? result
    return result
  end

  def self.school_sym(client)
    r = nil
    r = client[:school].to_sym if client[:school]
    return r
  end

  def self.school_district_sym(client)
    r =  if client[:school_district]
      client[:school_district].to_sym
    else
      :unknown
    end
    return r
  end

  def self.all_under_contract_with_sd( sd )
    client_array = Person::Client.by_school_array{ |client|
      right_sd = sd.same_sd?( client[:school_district] )
      under_contract = ( client[:result] == 'contract' or client[:result] == 'revenue' )
      use = ( under_contract and right_sd )
      use
    }
    return client_array
  end

  def self.with_logged_hours( sd, month, year )
    client_array = Person::Client.by_school_array{ |client|
      right_sd = sd.same_sd?( client[:school_district] )
      hrs_in_period = client.total_hours_in_period( month, year )
      zero_hrs_in_period = ( hrs_in_period == 0 )
      use = ( !zero_hrs_in_period and right_sd )
      use
    }
    return client_array
  end

  def self.hash_array_to_object_array( hash_array )
    return hash_array.map{ |h|
      r = self.create( h )
      r
    }
  end

# total_fc_sc_hrs
  def total_fc_sc_hrs
    client = self
    total_hrs = 0
    ['fc','sc'].each{ |c|
      [9,10,11,12,1,2,3,4,5,6,7,8].each{ |m|
        field_sym = "#{c}_hrs_#{m}".to_sym
        hrs=  client.class.clean_hours( client.send(field_sym) )
        total_hrs += hrs
      }
    }
    return total_hrs
  end

##########################################
# Class View Methods
##########################################

# representative_total
  def self.representative_total_hash(results)
    client = self
    t = 0
    [:revenue,:contract,:test_done,:testing,:test_only,:waiting_for_contract].each{ |rt|
      results.each_pair{ |sd_name,sd_hash|
        sd_hash.each_pair{ |sc_name,sc_hash|
          ar= sc_hash[rt]
          #ar= results[sdn][scn][rt]
          next if !ar
          l << "#{rt.to_s.dup} #{ar.length} ".dup if ar
          t += ar.length
        }
      }
    }
    return { :prompt_string => "representative total", :value_string => " #{t} [ #{l} ]" }
  end

  def self.representative_total_line( indent , results )
    return comlete_string( indent, representative_total_hash(results) )
  end

# binder_total
  def binder_total_hash(results)
    t = 0
    self.binder_types.each{ |rt|
      results.each_pair{ |sd_name,sd_hash|
        sd_hash.each_pair{ |sc_name,sc_hash|
          ar= sc_hash[rt]
          next if !ar
          l << "#{rt} #{ar.length} " if ar
          t += ar.length
        }
      }
    }
    return { :prompt_string => "binder total", :value_string => " #{t} [ #{l} ]" }
  end

  def binder_total_line( indent , results )
    return comlete_string( indent, binder_total_hash(results) )
  end

##########################################
# Object View Methods
##########################################

# representative
  def representative_line_hash
    client = self
    return { :prompt_string => "representative", :value_string =>  client[:representatives] }
  end

  def representative_line( indent=0 )
    return comlete_string( indent, representative_line_hash )
  end

# prep_line
  def prep_line_hash()
    return { :prompt_string => "prepped", :value_string => "[  ]" }
  end

  def prep_line( indent=0 )
    return comlete_string( indent, prep_line_hash() )
  end

# last_attended_line
  def last_attended_line_hash()
    client = self
    l = ""
    l << if client[:last_attended_date]
      "last attended #{client[:last_attended_date]}"
    else
      "has not previously attended"
    end
    return { :prompt_string => "last attended", :value_string => l }
  end

  def last_attended_line( indent=0)
    return comlete_string( indent, last_attended_line_hash )
  end

# attendance_line
  def attendance_line_hash()
    return { :prompt_string => "attended", :value_string => "[  ]" }
  end

  def attendance_line( indent=0 )
    return comlete_string( indent, last_attended_line_hash )
  end

# updated_line
  def updated_line_hash
    client = self
     #return nil if !self.binder_types.include? client[:result]
    return { :prompt_string => "updated", :value_string => "[  ]" }
  end

  def updated_line( indent=0 )
    return comlete_string( indent, updated_line_hash )
  end

# invoice_hrs
   def invoice_hrs_line_hash( month , year )
    client = self
    l = ""
    fc_hours = client.fc_hours_in_period(month,year)
    sc_hours = client.sc_hours_in_period(month,year)
    return { 
      :prompt_string =>  "month / fc_hrs / sc_hrs",
      :value_string =>  "#{ month } / #{ fc_hours } / #{ sc_hours }"
    }
  end

  def invoice_hrs_line( month , year , indent=0 )
    return comlete_string( indent, invoice_hrs_line_hash )
  end

# client_line
   def client_line_hash()
    client = self
    l = ""
    l<< "#{ client[:client_id].to_i } #{ client[:last_name] } , #{ client[:first_name]}"
    return { :prompt_string => "", :value_string =>  l }
  end

  def client_line( indent=0 )
    return comlete_string( indent, client_line_hash )
  end

# result_line
  def result_line_hash()
    client= self
    return { :prompt_string => "result", :value_string =>  "#{ client[:result] }" }
  end

  def result_line( indent=0 )
    return comlete_string( indent, result_line_hash )
  end

# invoice_audit
  def invoice_audit_line_hash()
    client = self
    return { :prompt_string => "Total fc plus sc hrs", :value_string =>  client.total_fc_sc_hrs }
  end

  def invoice_audit_line( indent=0 )
    return comlete_string( indent, invoice_audit_line_hash )
  end

# contract_hours
  def contract_hours_line_hash()
    client = self
    l = nil
    result = client.result.to_sym if client.result
    result = :other if !client.class.result_types.include? result
    if [:revenue,:contract,:contract_dead].include? result
      return {
        :prompt_string => "Last Consumed Hour/Contracted Hours", 
        :value_string =>  "#{ client.last_consumed_hour} / #{ client.contracted_hours }"
      }
    else
      return  {
        :prompt_string => "Result not in [:revenue,:contract,:contract_dead] ", 
        :value_string =>  ""
      }
    end
  end

  def contract_hours_line( indent=0 )
    return comlete_string( indent, contract_hours_line_hash )
  end

# grade
  def grade_line_hash()
    client = self
    return { :prompt_string => "grade", :value_string =>  client[:grade].to_i }
  end

  def grade_line( indent=0 )
    return comlete_string( indent, grade_line_hash )
  end

# origin
  def origin_line_hash()
    client = self
    return { :prompt_string => "origin", :value_string =>  client[:origin] }
  end

  def origin_line( indent=0 )
    return comlete_string( indent, origin_line_hash )
  end

# phone
  def fix_phone_num(pn)
    r= if pn then pn.strip.split(' ').join('-').strip else '' end
  end

  def phone_line_hash()
    client = self
    return { 
      :prompt_string => "phone 1/2/3",
      :value_string =>  "#{fix_phone_num(client[:phone_1])} #{ fix_phone_num(client[:phone_2]) } #{ fix_phone_num(client[:phone_3]) }".strip
    }
  end

  def phone_line( indent=0 )
    return comlete_string( indent, phone_line_hash )
  end

###################
#
###################
  def class_field_list
    [
      :representative_total,
      :binder_total
    ]
  end

  def instance_field_list
    [
      :last_attended,
      :prep,
      #:invoice_hrs,
      :updated,
      :attendance,
      :representative,
      :client,
      :result,
      :invoice_audit,
      :contract_hours,
      :phone,
      :origin,
      :grade
    ]
  end

  def inspect_pretty
    lines = []
    instance_field_list.map{ |f|
#p f
      lines << self.send( "#{f.to_s}_line".to_sym)
    }
    return lines
  end

  def color
    r = if self.result == 'revenue' then "000099" else "660066" end
  end

end
