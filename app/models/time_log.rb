class TimeLog < ActiveRecord::Base
  belongs_to :activity
  belongs_to :user

  def hours_logged
    return seconds_logged/60/60
  end

  def seconds_logged
    return 0 if end_time.nil?
    return self.end_time-self.start_time
  end

  def during?(period=:all)
    case period.to_s
      when 'all'
        true
      when 'last_minute'
        self.start_time + 1.minute > Time.now
      when 'last_hour'
        self.start_time + 1.hour > Time.now
      when 'last_day'
        self.start_time + 1.day > Time.now
      when 'last_week'
        self.start_time + 1.week > Time.now
      when 'last_month'
        self.start_time + 1.month > Time.now
      when 'last_quarter'
        self.start_time + 3.month > Time.now
      when 'last_year'
        self.start_time + 1.year > Time.now
    end
  end

end

