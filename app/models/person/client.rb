class Person::Client  < ActiveRecord::Base

  set_table_name ('person_clients')

  def self.csv_line(client,indent=0)
    l = ""
    l<< "#{ client[:result] }"
    return l
  end

  def self.each_client (&block)
    Spreadsheet::CurrentClients.each_client{ |client|
      yield(client)
    }
  end

  def self.binder_types
    [:revenue,:contract]
  end

  def self.binder_total(indent,results)
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

  def self.representative_total(indent,results)
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

  def self.prep_line(client,indent=0)
    return nil if !self.binder_types.include? client[:result]
    l = ""
    indent.times{ l<<' ' }
    l<< "prepped => [          ]"
    return l
  end

  def self.last_attended_line(client,indent=0)
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

  def self.attendance_line(client,indent=0)
    #return nil if !self.binder_types.include? client[:result]
    l = ""
    indent.times{ l<<' ' }
    l<< "attended => [          ]"
    return l
  end

  def self.updated_line(client,indent=0)
    #return nil if !self.binder_types.include? client[:result]
    l = ""
    indent.times{ l<<' ' }
    l<< "updated => [          ]"
    return l
  end

  def self.csv_keys
    [:student_first_name,:student_last_name,:district_name,:district_code,:client_code,:period_month,:period_year,:invoice_date,:school,:district_city,:district_state,:district_zip,:fc_rate,:sc_rate,:fc_hours,:sc_hours,:fc_amount,:sc_amount,:amount,:per_pupil_amount,:hours_in_program]
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

    r[:district_name] = sd.name.gsub('_',' ')
    r[:district_city] = sd_rec[:city]
    r[:district_state] = sd_rec[:state]
    r[:district_zip] = sd_rec[:zip]

    r[:invoice_date] =  Date.today
#Invoice.get[:invoice_date]

    #sd_ca = Contract::SchoolDistrict.get_for_sd(sd)
    #fc = sd_ca[0]

    fc = Contract::SchoolDistrict.fc_for_sd(sd)

    r[:fc_name]= fc[:name]
    r[:sc_name]= nil

    r[:per_pupil_amount]= fc[:per_pupil_amount]
    r[:fc_hours] = fc_hours = self.fc_hours_in_period(client_hash,month,year)

    r[:fc_rate] = fc_rate = fc[:rate]
    r[:fc_amount] = fc_amount = fc_hours * fc_rate

    if Contract::SchoolDistrict.has_sc?(sd)
    #if sd_ca.length == 1
      r[:hours_in_program]= fc[:hours_in_program]
      sc_amount= 0
      r[:sc_hours] = sc_hours = 0
    else
      sc = Contract::SchoolDistrict.fc_for_sd(sd)
      #sc = sd_ca[1]
      r[:sc_name]= sc[:name]

      r[:sc_hours] = sc_hours = self.sc_hours_in_period(client_hash,month,year)
      r[:sc_rate] = sc_rate = sc[:rate]
      r[:sc_amount]= sc_amount = sc_hours * sc_rate
    end

    if fc_hours == 0 and sc_hours == 0
      p "record wo hours! #{r.inspect}"
    end

    r[:total_amount]= fc_amount + sc_amount

    r[:invoice_number] = "SD#{r[:district_code]}_C#{r[:client_id]}_P#{year}_#{month}"

    return r
  end

  def self.total_hours_in_period(client_hash,month,year)
      return self.fc_hours_in_period(client_hash,month,year) + self.sc_hours_in_period(client_hash,month,year)
  end

  def self.fc_hours_in_period(client_hash,month,year)
    fc_hrs_field_sym = "fc_hrs#{month}".to_sym
    fc_hours = client_hash[fc_hrs_field_sym]
    fc_hours ||= 0
    return fc_hours
  end

  def self.sc_hours_in_period(client_hash,month,year)
    sc_hrs_field_sym = "sc_hrs#{month}".to_sym
    sc_hours = client_hash[sc_hrs_field_sym]
    sc_hours ||= 0
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
          yield self.representative_total(4,results)
          yield self.binder_total(4,results)
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
                yield Person::Client.client_line(client,6)
                yield Person::Client.prep_line(client,6)
                yield Person::Client.last_attended_line(client,8)
                yield Person::Client.attendance_line(client,8)
                yield Person::Client.updated_line(client,8)
                yield Person::Client.phone_line(client,8)
                yield Person::Client.result_line(client,8) if rt == :other
                yield Person::Client.grade_line(client,8)
                yield Person::Client.origin_line(client,8)
                yield Person::Client.invoice_hrs_line(client,month,year,8)
                yield Person::Client.representative_line(client,8)
                ch= Person::Client.contract_hours_line(client,8)
                yield ch if ch
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
      #Person::Client.each_client{ |client|
      client_array.each{ |client|
      #Spreadsheet::CurrentClients.each_client{ |client|
        #next if block_given? and !yield(client)
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

  def self.invoice_hrs_line(client,month,year,indent=0)
    l = ""
    indent.times{ l<<' ' }
    fc_hours = self.fc_hours_in_period(client,month,year)
    sc_hours = self.sc_hours_in_period(client,month,year)
    l<< "month => #{ month } fc_hrs => #{ fc_hours } sc_hrs => #{ sc_hours }"
    return l
  end

  def self.representative_line(client,indent=0)
    l = ""
    indent.times{ l<<' ' }
    l<< "representative => #{ client[:representatives] }"
    return l
  end

  def self.client_line(client,indent=0)
    l = ""
    indent.times{ l<<' ' }
    l<< "#{ client[:client_id].to_i } #{ client[:last_name] } , #{ client[:first_name]}"
    return l
  end

  def self.result_line(client,indent=0)
    l = ""
    indent.times{ l<<' ' }
    l<< "result => #{ client[:result] }"
    return l
  end

  def self.contract_hours_line(client,indent=0)
    l= nil
    result= client[:result].to_sym if client[:result]
    result= :other if !result_types.include? result
    if [:revenue,:contract,:contract_dead].include? result
      l = ""
      indent.times{ l<<' ' }
      l<< "Contracted Hours => #{ client[:contracted_hours] }"
      l<< " , "
      l<< "Last Consumed Hour => #{ client[:last_consumed_hour] }"

    end
    return l
  end

  def self.grade_line(client,indent=0)
    l= ""
    indent.times{ l<< ' ' }
    l<< "grade => #{ client[:grade].to_i }"
    return l
  end

  def self.origin_line(client,indent=0)
    l= ""
    indent.times{ l<< ' ' }
    l<< "origin => #{ client[:origin] }"
    return l
  end

  def self.phone_line(client,indent=0)
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
      right_sd = ( client[:school_district] == sd.code_name )
      hrs_in_period = Person::Client.total_hours_in_period( client, month, year )
      zero_hrs_in_period = ( hrs_in_period == 0 )
      use= ( !zero_hrs_in_period and right_sd )
#p "id #{client[:client_id].to_i} #{use} right_sd: #{right_sd} hrs_in_period #{hrs_in_period}"
      use
    }
    return client_array
  end

  def self.hash_array_to_object_array( hash_array )
    return hash_array.map{ |h|
#p "h #{h.inspect}"
      r= self.create( h )
#p "r #{r}"
       r
    }
  end

end
