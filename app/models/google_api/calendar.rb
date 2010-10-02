require 'gcal4ruby'

class GoogleApi::Calendar < GoogleApi::Client
  cattr_accessor :list

  def self.service_class
    GCal4Ruby::Service
  end

  def self.get_list
    return self.list if !self.list.nil?
    self.login
    self.list = service.calendars
    return self.list
  end

  def self.hash(c)
    { :events => c.events.map{ |e| event_hash(e) } }
  end
 
  def self.content_hash(content)
    r= {}
    return r if content.nil?
    content_array= content.split("\n").map{|line| line.match(/(.*):(.*)/)}.compact
    content_array.each{ |m|
      r[ m[1].underscore.to_sym ]= m[2]
    }
    return r
  end

  def self.event_hash(e)
    r= {}
    r[:start_time]= e.start_time()
    r[:end_time]= e.end_time()
    difference =   r[:end_time] - r[:start_time] 
    r[:duration]=   difference/60/60 
    r.merge!( self.content_hash(e.content) )
    return r
  end

  def self.client_id(c)
    m= c.title.match(/(.*)__(.*)/)
    return nil if m.nil? or m.length<3
    m2= m[2].match(/Client_(.*)/)
    return nil if m2.nil? or m.length< 2
    return m2[1].to_i
  end

  def self.tutor_id(c)
    m= c.title.match(/(.*)__(.*)/)
    return nil if m.nil? or m.length<3
    m2= m[2].match(/Tutor_(.*)/)
    return nil if m2.nil? or m.length< 2
    return m2[1].to_i
  end

  def self.get_client_calendar_hash
    r={}
    self.get_list.each{ |c|
      id= client_id(c)
      r[id]=c if !id.nil?
    }
    return r
  end

  def self.get_tutor_calendar_hash
    r={}
    self.get_list.each{ |c|
      id= tutor_id(c)
      r[id]=c if !id.nil?
    }
    return r
  end

end
