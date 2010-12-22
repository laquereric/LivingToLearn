class Period
  attr_accessor :begin_time
  attr_accessor :end_time

  def self.update_cycle(cycle_key)
    period= self.new
    period.begin_time= Time.now
    case cycle_key
      when :monday_am
         period.begin_time= Time.now+7.days
    end
    return period
  end

  def self.this_school_year(ref=Time.now)
    period= self.new
    begin_year= if ref.month >= 9 then ref.year else ref.last_year.year end
    period.begin_time= Time.utc(begin_year,"sep").at_beginning_of_month

    end_year= begin_year+1
    period.end_time= Time.utc(end_year,"aug").end_of_month

    return period
  end

  def self.last_school_year
    return self.this_school_year( Time.now - 1.year )
  end

  def self.next_school_year
    return self.this_school_year( Time.now + 1.year )
  end

#################

  def self.this_half_month(ref=Time.now)
    period= self.new

    period.begin_time= if ref.day >= 15 then
      Time.utc(
         ref.year,
         Time::RFC2822_MONTH_NAME[ref.month-1],
         16
      ).at_beginning_of_day
    else 
      Time.utc(
         ref.year,
         Time::RFC2822_MONTH_NAME[ref.month-1]
      ).at_beginning_of_month
    end

    period.end_time= if ref.day >= 15 then
      ref.at_end_of_month
    else 
      Time.utc(
        ref.year,
        Time::RFC2822_MONTH_NAME[ref.month-1],
        15
      ).end_of_day
    end

    return period
  end

  def self.last_half_month()
    return this_half_month( Time.now - 15.days )
  end

  def self.next_half_month()
    return this_half_month( Time.now + 15.days )
  end

############

  def self.this_month(ref=Time.now)
    period= self.new

    period.begin_time= ref.at_beginning_of_month
    period.end_time= ref.end_of_month

    return period
  end

  def self.last_month()
    return this_month( Time.now - 1.month )
  end

  def self.next_month()
    return this_month( Time.now + 1.month )
  end

#####################

  def self.today( ref= Time.now )
    period= self.new

    period.begin_time= ref.at_beginning_of_day
    period.end_time= ref.end_of_day

    return period
  end

  def self.yesterday()
    return self.today( Time.now - 1.day )
  end

  def self.tomorrow()
    return self.today( Time.now + 1.day )
  end

end
