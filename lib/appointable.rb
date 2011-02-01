module Appointable

  def has_appointments?
    return ( self.scheds.length > 0 )
  end

  def next_appointment_dates( reference_time = DateTime.now , sequence_length = 3  )
    appointment_array = self.appointments
    mapped_appointment_dates = Appointment::Recurring.specifically_map(
      appointment_array , reference_time, sequence_length
    )
    return mapped_appointment_dates
  end

  def raw_sched_durs
    sa_raw = ['a','b','c','d','e','f','g'].map{ |c|
      sched_sym = "sched_#{c}".to_sym
      sched = self.send(sched_sym)
      sched = nil if sched and sched.length == 0

      dur_sym = "dur_#{c}".to_sym
      dur = self.send(dur_sym)
      dur = nil if dur and dur.length == 0

      [sched,dur]
    }
    sa = sa_raw.select{ |ar| !ar[0].nil? }
    sa
  end

  def appointments
    psa = self.raw_sched_durs.map{ |raw_sched_dur|
      Appointment::Recurring.create_from_raw_sched_dur(self,raw_sched_dur)
    }
  end

  def appointments_on(day_of_week)
    appointments.select{ |appointment| appointment.day_of_week == day_of_week }
  end

end

