class Appointment < ActiveRecord::Base

  def self.all_on_weekday(day_of_week)
     unsorted = Person::Client.all.map { |client|
       appointments = client.appointments_on( day_of_week ) #.map{ |appt_array|
       appointments = nil if appointments.length == 0
       appointments
     }.flatten.compact
     sorted = unsorted.sort{ |x,y|
       x.to_minutes <=>  y.to_minutes
     }
     return unsorted
  end

  def client
    Person::Client.find_by_client_id(self.client_id.to_f)
  end

  def next_location
    "Woodbury High"
  end

  def next_time
    "Wednesday January 19 at 2:45 PM"
  end

  def this_appointment
    Appointment.this_appointment_for(self)
  end

  def next_appointment
    Appointment.next_appointment_for(self)
  end

  def this_location
    "Woodbury High"
  end

  def this_time
    "Monday January 17 at 2:45 PM"
  end

  def self.create_from_raw_sched(client,raw_sched)
    h = self.parse_sched( raw_sched )
    h[:client_id] = client.client_id
    return create_from_sched( h )
  end

  def self.create_from_sched( sched )
    self.create( sched )
  end

  def to_minutes()
    r = self

    am_pm_min = if r[:am_pm]='PM' then 60*12 else 0 end
    hour_min = r[:hour]*12
    return am_pm_min + hour_min + r[:minute]
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

  def self.parse_sched( sched )
    return nil if sched.nil? or sched.length == 0
    sa = sched.split('_')
    r = {}
    r[:loc] = sa[0]
    r[:day_of_week] = sa[1].to_s
    ha = sa[2].split(':')
    if ha.length == 2
      r[:hour] = ha[0].to_i
      r[:minute] = ha[1].to_i
    else
      r[:hour] = sa[2].to_i
      r[:minute] = 0
    end

    r[:am_pm] = sa[3]
    r[:tentative] = if sa.length == 5 and sa[4] == 'Q' then true else false end
    return r

  end

end
