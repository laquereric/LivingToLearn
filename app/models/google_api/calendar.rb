require 'gcal4ruby'
require 'tzinfo'

class GoogleApi::Calendar < GoogleApi::Client

  def self.sched_to_minutes(r)
    am_pm_min = if r[:am_pm]='PM' then 60*12 else 0 end
    ra = r[:hour].split(':')
    hour_min = ra[0].to_i * 60
    min_min = if ra.length>1 then ra[1].to_i else 0 end
    return am_pm_min + hour_min + min_min
  end

  def self.sched_for_day(sa,day)
    sa.select{ |sched| sched[:day] == day }
  end

  def self.sched_on_day(sa,day)
    return ( sched_for_day(sa,day).length > 0 )
  end

  def self.sched_at_loc(loc)
    rs= sa.select{ |sched| r[:loc] == loc }
    return ( rs.length > 0 )
  end

  def self.parse_sched(sched)

    sa = sched.split('_')
    r = {}
    r[:loc] = sa[0]
    r[:day] = sa[1]
    r[:hour] = sa[2]
    r[:am_pm] = sa[3]
    r[:tentative] = if sa.length == 5 and sa[4] == 'Q' then true else false end
    return r

  end

  def self.missing_ids
     lines=[]
     list= self.cache_dump.keys.select{ |k| /_x/.match(k) }
     list.each{ |m_id|
         lines<< m_id
     }
     return lines
  end

  def self.service_class
    GCal4Ruby::Service
  end

############
#
############

   def self.cache_name
     'gcal_calendar_titles'
   end

   def self.cache_dump   
      Rails.cache.read(self.cache_name)
   end

   def self.cache_load
     GoogleApi::Calendar.login
     Rails.cache.delete(self.cache_name)
     Rails.cache.fetch(self.cache_name) {
       cache= {}
       list= GoogleApi::Calendar.get_list
       list.each{ |cal|
p "cal.title: #{cal.title}"
         next if cal.title.nil? or cal.title.length==0
         events_array= cal.events.map{ |e| 
           self.event_hash(e) 
         }
         ch= { 
           :title => cal.title,
           :gcal_calendar_url => self.gcal_calendar_url( cal.id ),
           :events => events_array
         }
         if ( cid = client_id(cal) )
           ch[:client_id]= cid
         end
         if ( tid = tutor_id(cal) )
           ch[:tutor_id]= tid
         end
         cache[cal.title]= ch
       }
p "fetched"
       cache
    }
  end

###########
#
###########

  def self.gcal_calendar_url(id)
    id.gsub('%40','@')
  end

  def self.gcal_event_url(id)
    id.gsub('%40','@')
  end

##############
#
##############

  def self.local_dst?
    Time.now.dst?
  end

  def self.from_utc(ut)
    l=ut
    l= if self.local_dst?
      l+1.hour
    else
      l
    end
    return l.in_time_zone('EST')
  end

  def self.to_utc(lt)
    r= lt.in_time_zone()
    return r
  end

  def self.event_hash(e)
    r= {}
    r[:url]= self.gcal_event_url(e.id)
    r[:title]= e.title
    r[:raw_content]= e.content
    r[:start_time]= e_start_time = self.to_utc( e.start_time() )
    r[:end_time]= e_end_time =   self.to_utc( e.end_time() )
    difference =   e_end_time - e_start_time
    r[:duration]=   difference/60/60 
    r.merge!( self.content_hash(e.content) )
    return r
  end

###########
#
###########

  def self.client_id(c)
    m= c.title.match(/(.*)__(.*)/)
    return nil if m.nil? or m.length<3
    m2= m[2].match(/Client_(.*)/)
    return nil if m2.nil? or m.length< 2
    id= m2[1].to_i
    return id
  end

  def self.tutor_id(c)
    m= c.title.match(/(.*)__(.*)/)
    return nil if m.nil? or m.length<3
    m2= m[2].match(/Tutor_(.*)/)
    return nil if m2.nil? or m.length< 2
    return m2[1].to_i
  end

###########
#
###########
 
  def self.content_hash(content)
    r= {}
    return r if content.nil?
    content_array= content.split("\n").map{|line| line.match(/(.*):(.*)/)}.compact
    content_array.each{ |m|
      r[ m[1].underscore.to_sym ]= m[2]
    }
    return r
  end

###########
#
###########

  def self.each_event()
    self.cache_dump.values.each{ |calendar|
      calendar[:events].each{ |event|
        before= event[:start_time] < period.begin_time
        after= event[:start_time] > period.end_time
        yield(calendar,event)
      }
    }
  end

  def self.each_event_in_period(period)
    self.cache_dump.values.each{ |calendar|
      calendar[:events].each{ |event|
        before= event[:start_time] < period.begin_time
        after= event[:start_time] > period.end_time
        yield(calendar,event) if !before and !after
      }
    }
  end

  def self.get_list
    self.login
    return service.calendars
  end
###############
#
###############
  def self.event_stings(c,e) 
    r=[]
    r<< "Calendar #{c[:title]}"
    r<< "  title #{e[:title]}"
    #r<< "  start_time_utc #{ e[:start_time] }"
    r<< "  start_time #{  self.from_utc( e[:start_time]) }"
    r<< "  end_time #{  self.from_utc( e[:end_time] ) }"
    r<< "  duration #{e[:duration]}"
  end

end
