class Person::Client #< Person::PersonDetail

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

  def self.by_school_report(results,&block)
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

  def self.by_school_hash (&block)
      results= {}
      Person::Client.each_client{ |client|
      #Spreadsheet::CurrentClients.each_client{ |client|
        next if block_given? and !yield(client)
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

  #set_table_name :person_church_leaders
  #belongs_to :organization_church_detail, :class_name => "Organization::Church", :foreign_key => :organization_church_detail_id

end
