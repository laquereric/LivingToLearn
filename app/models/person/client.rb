class Person::Client  < ActiveRecord::Base

  set_table_name ('person_clients')

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

  def binder_total(indent,results)
    client= self
     t=0
    i="";indent.times{ i<< ' ' };
    l=""
    self.binder_types.each{ |rt|
      results.each_pair{ |sd_name,sd_hash|
        sd_hash.each_pair{ |sc_name,sc_hash|
          ar= sc_hash[rt]
          #ar= results[sdn][scn][rt]
          next if !ar
          l << "#{rt} #{ar.length} " if ar
          t += ar.length
        }
      }
    }
    return "#{i}binder total #{t} [ #{l} ]"
  end

  def representative_total(indent,results)
    client= self
     t=0
    i="";indent.times{ i<< ' ' };
    l=""
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
    return "#{i}representative total #{t} [ #{l} ]"
  end

  def prep_line(indent=0)
    client= self
     return nil if !client.class.binder_types.include? client[:result]
    l = ""
    indent.times{ l<<' ' }
    l<< "prepped => [          ]"
    return l
  end

  def last_attended_line(indent=0)
    client= self
     l = ""
    indent.times{ l<<' ' }
    l << if client[:last_attended_date]
      "last attended #{client[:last_attended_date]}"
    else
      "has not previously attended"
    end
    l <<  "        last attended hour [     ]"
    return l
  end

  def attendance_line(indent=0)
     client= self
    #return nil if !self.binder_types.include? client[:result]
    l = ""
    indent.times{ l<<' ' }
    l<< "attended => [          ]"
    return l
  end

  def updated_line(indent=0)
    client = self
     #return nil if !self.binder_types.include? client[:result]
    l = ""
    indent.times{ l<<' ' }
    l<< "updated => [          ]"
    return l
  end

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

  def self.invoice_hash(month,year,client_hash)
    r={}

    r[:director_name] = 'Eric Laquer'

    r[:testing_fee] = 0
    r[:registration_fee] = 0
    r[:client_id]= client_hash[:client_id].to_i
    r[:student_first_name]= client_hash[:first_name]
    r[:student_last_name]= client_hash[:last_name]

    r[:school]=client_hash[:school]
    sd = Government::SchoolDistrict.for_code_name( client_hash[:school_district] )
    Government::SchoolDistrict.nj_cache()

    sd_id = Government::SchoolDistrict.id_from_code_name( client_hash[:school_district] )
    r[:district_code] = sd_id
    sd_rec = Government::SchoolDistrict.nj_cache[ sd_id ]
p "bad sd_id #{sd_id} from #{ client_hash[:school_district] } " if sd_rec.nil?
    r[:district_name] = sd.name.gsub('_',' ')
    r[:district_city] = sd_rec[:city]
    r[:district_state] = sd_rec[:state]
    r[:district_zip] = sd_rec[:zip]

    r[:invoice_date] =  Date.today

    fc = Contract::SchoolDistrict.fc_for_sd(sd)

    r[:fc_name]= fc[:name]
    r[:sc_name]= nil

    r[:per_pupil_amount]= fc[:per_pupil_amount]
    r[:fc_hours] = fc_hours = client_hash.fc_hours_in_period(month,year)

    r[:fc_rate] = fc_rate = fc[:rate]
    r[:fc_amount] = fc_amount = fc_hours * fc_rate

    r[:sc_name] = sc_name = nil
    r[:sc_amount] = sc_amount= 0
    r[:sc_hours] = sc_hours = 0
    r[:sc_rate] = sc_rate = 0

    if not(Contract::SchoolDistrict.has_two_contracts?(sd) or
      Contract::SchoolDistrict.has_master_slave_contracts?(sd) )
      r[:hours_in_program]= fc[:hours_in_program]
   else
      sc = Contract::SchoolDistrict.sc_for_sd(sd)
      r[:sc_name]= sc[:name]
      r[:sc_hours] = sc_hours = client_hash.sc_hours_in_period(month,year)
      r[:sc_rate] = sc_rate = sc[:rate]
      r[:sc_amount]= sc_amount = sc_hours * sc_rate
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

    r[:total_amount]= fc_amount + sc_amount

    r[:invoice_number] = "SD#{r[:district_code]}_C#{r[:client_id]}_P#{year}_#{month}"

    return r
  end

  def total_hours_in_period(month,year)
    client = self
    return client.fc_hours_in_period(month,year) + client.sc_hours_in_period(month,year)
  end

  def self.clean_hours(raw)
    c =  case raw.class.to_s
      when 'String' : raw.to_i
      when 'Float' : raw
      when 'NilClass' : 0
    end
    return c
  end

  def fc_hours_in_period(month,year)
    client = self
    fc_hrs_field_sym = "fc_hrs#{month}".to_sym
    raw = client[fc_hrs_field_sym]
    fc_hours =  client.class.clean_hours(raw)
    return fc_hours
  end

  def sc_hours_in_period(month,year)
    client = self
    sc_hrs_field_sym = "sc_hrs#{month}".to_sym
    raw = client[sc_hrs_field_sym]
    sc_hours =  client.class.clean_hours(raw)
    return sc_hours
  end

  def self.by_school_report(results,month,year,&block)
        total_consumed_hours = 0
        results.each_key{ |sdn|
        "++++++++++++++++++++++++++++++++"
        yield "School District - #{sdn.to_s}"
        yield "++++++++++++++++++++++++++++++++"
        yield ""
        results[sdn].each_key{ |scn|
          yield "  ------------------------------"
          yield "  School - #{scn.to_s}"
          yield "  -------------------------------"
          #yield client.representative_total(4,results)
          #yield client.binder_total(4,results)
          Person::Client.result_types.each{ |rt|
              next if !results[sdn][scn][rt] or results[sdn][scn][rt].length == 0
              yield ""
              l="";4.times{ l<< ' ' };
              l<< "result => #{rt} - #{results[sdn][scn][rt].length}"
              yield l
              l="";4.times{ l<< ' ' };
              l<< Person::Client.result_type_key[rt]
              yield l if rt != :other
              results[sdn][scn][rt].each{ |client|
                if  client[:last_consumed_hour] and client[:last_consumed_hour].is_a? Fixnum
                  total_consumed_hours += client[:last_consumed_hour]
                end
                yield client.client_line(6)
                yield client.prep_line(6)
                yield client.last_attended_line(8)
                yield client.attendance_line(8)
                yield client.updated_line(8)
                yield client.phone_line(8)
                yield client.result_line(8) if rt == :other
                yield client.grade_line(8)
                yield client.origin_line(8)
                yield client.invoice_hrs_line(month,year,8)
                yield client.representative_line(8)
                if ( ch= client.contract_hours_line(8) )
                  yield ch
                end
                if ( cial = client.invoice_audit_line(8) )
                  yield cial
                end
                yield ""
              }
          }
        }
      }
      yield "Total Consumed Hours: #{total_consumed_hours}"
      yield ""
  end

  def self.by_school_array (&block)
    rs=[]
    Person::Client.each_client{ |client|
      next if block_given? and !yield(client)
      rs<< client
    }
    return rs
  end

  def self.by_school_hash (client_array)
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

  def invoice_hrs_line(month,year,indent=0)
    client=self
    l = ""
    indent.times{ l<<' ' }
    fc_hours = client.fc_hours_in_period(month,year)
    sc_hours = client.sc_hours_in_period(month,year)
    l<< "month => #{ month } fc_hrs => #{ fc_hours } sc_hrs => #{ sc_hours }"
    return l
  end

  def representative_line(indent=0)
    client= self
    l = ""
    indent.times{ l<<' ' }
    l<< "representative => #{ client[:representatives] }"
    return l
  end

  def client_line(indent=0)
    client= self
    l = ""
    indent.times{ l<<' ' }
    l<< "#{ client[:client_id].to_i } #{ client[:last_name] } , #{ client[:first_name]}"
    return l
  end

  def result_line(indent=0)
    client= self
    l = ""
    indent.times{ l<<' ' }
    l<< "result => #{ client[:result] }"
    return l
  end

  def total_fc_sc_hrs
    client= self
    total_hrs = 0
    ['fc','sc'].each{ |c|
      [9,10,11,12,1,2,3,4,5,6,7,8].each{ |m|
        field_sym = "#{c}_hrs#{m}".to_sym
        hrs=  client.class.clean_hours( client.send(field_sym) )
        total_hrs += hrs
      }
    }
    return total_hrs
  end

  def invoice_audit_line(indent=0)
    client=self
    l = ""
    indent.times{ l<<' ' }
    l<< "Total fc plus sc hrs => #{ client.total_fc_sc_hrs }"
    return l
  end

  def contract_hours_line(indent=0)
    client=self
    l= nil
    result= client.result.to_sym if client.result
    result= :other if !client.class.result_types.include? result
    if [:revenue,:contract,:contract_dead].include? result
      l = ""
      indent.times{ l<<' ' }
      l<< "Contracted Hours => #{ client.contracted_hours }"
      l<< " , "
      l<< "Last Consumed Hour => #{ client.last_consumed_hour }"

    end
    return l
  end

  def grade_line(indent=0)
    client=self
    l= ""
    indent.times{ l<< ' ' }
    l<< "grade => #{ client[:grade].to_i }"
    return l
  end

  def origin_line(indent=0)
    client=self
    l= ""
    indent.times{ l<< ' ' }
    l<< "origin => #{ client[:origin] }"
    return l
  end

  def phone_line(indent=0)
    client=self
    l= ""
    indent.times{ l<< ' ' }
    l<< "phone_1 => #{ client[:phone1] } phone_2 => #{ client[:phone2] }"
    return l
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

  def self.with_logged_hours( sd, month, year )
    client_array = Person::Client.by_school_array{ |client|
      right_sd = sd.same_sd?( client[:school_district] )
      hrs_in_period = client.total_hours_in_period( month, year )
      zero_hrs_in_period = ( hrs_in_period == 0 )
      use= ( !zero_hrs_in_period and right_sd )
      use
    }
    return client_array
  end

  def self.hash_array_to_object_array( hash_array )
    return hash_array.map{ |h|
      r= self.create( h )
       r
    }
  end

end
