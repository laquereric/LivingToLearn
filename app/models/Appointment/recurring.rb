class Appointment::Recurring < ActiveRecord::Base
  set_table_name :appointments

  def self.specifically_map( appointment_array , reference_time = DateTime.now , sequence_length = 3 )
#p "appointment_array : #{appointment_array.inspect}"
    results = []
    return results if appointment_array.length==0

    offset_array = self.offset_to_reference( appointment_array , reference_time )
#p "offset_array : #{offset_array.inspect}"
    modulus = offset_array.length
    cursor_time = reference_time

    (0..(sequence_length-1)).each{ |appointment_number|

      cursor_week_minutes = self.reference_week_minutes(cursor_time)

      next_appointment = offset_array[appointment_number % modulus]
      next_appointment_week_minutes = next_appointment.week_minutes

      later_this_week = ( next_appointment_week_minutes > cursor_week_minutes )

      days_from_cursor = if later_this_week
        next_appointment.day_index - cursor_time.wday
      else
        days_to_end_of_week = 7 - cursor_time.wday
        days_to_end_of_week + next_appointment.day_index
      end

      next_date_time = cursor_time.at_midnight
      next_date_time += days_from_cursor.days

      hours =  next_appointment.hour
      hours += 12 if next_appointment.am_pm = "PM"
      next_date_time += hours.hours

      next_date_time += next_appointment.minute.minutes

      results << next_date_time
      cursor_time = next_date_time
    }

    return results

  end

  def self.offset_to_reference( appointment_array, reference_time = DateTime.now )
    modulus = appointment_array.length

    reference_week_minutes = self.reference_week_minutes(reference_time)
#p "reference_week_minutes #{reference_week_minutes}"
    sorted_array = appointment_array.sort{ |x,y|
       x.week_minutes <=>  y.week_minutes
    }
    next_appointment_index = nil
    sorted_array.each_index{ |index|
      this_week_minutes = sorted_array[index].week_minutes
#p "this_week_minutes #{this_week_minutes}"
       if  next_appointment_index.nil? and this_week_minutes > reference_week_minutes
        next_appointment_index = index
        break
      end
    }
#p "next_appointment_index #{next_appointment_index}"
#p "modulus #{modulus}"
    offset_array = []
    sorted_array.each_index{ |i|
      index = (next_appointment_index+i) % modulus
#p "i: #{i} index: #{index}"
      offset_array << sorted_array[index]
    }
    return offset_array
  end

  def self.reference_week_minutes(ref)
    return ref.wday*24*60 + ref.hour*60
  end

  def week_minutes()
    return self.day_index*24*60 + self.to_minutes
  end

  def day_index()
    self.class.day_abbreviations.index(self.day_of_week)
  end

  def self.day_abbreviations
    ["SUN" , "MON" , "TU", "WED" , "THUR" , "FRI", "SAT"]
  end

  def self.all_on_weekday(day_of_week)
     unsorted = Person::Client.all.map { |client|
       appointments = client.appointments_on( day_of_week )
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

  def next_time
    "Wednesday January 19 at 2:45 PM"
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
