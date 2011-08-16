class Activity < ActiveRecord::Base
  belongs_to :user
  acts_as_nested_set :dependent => :destroy
  has_many :time_logs, :dependent => :destroy

  def self.for_user(user)
    return self.all.select{ |r| r.user_id == user.id }
  end

  def parent_id
    return ( self.parent.nil? ? nil : self.parent.id )
  end

  def hours_logged_during(period=:all)
    return self.hours_list_during(period).sum
  end

  def hours_list_during(period=:all)
    self.time_log_entries_during(period).map{ |time_log_entry|
      time_log_entry.hours_logged
    }
  end

  def time_log_entries_during(period=:all)
    self.full_time_log_set.select{ |time_log|
      time_log.during?(period)
    }
  end

  def full_time_log_set
    r = self.full_set.map{ |activity| activity.time_logs }
    return r.flatten
  end

  def full_set()
    r = [self]
    r << self.children.map{ |child|
      child.full_set
    }
    return r.flatten
  end

  def self.sort_hier( activity_list )
    min_level= activity_list.map{ |activity| activity.level }.min
    top_level_activities= activity_list.select{ |activity| activity.level == min_level }
    return top_level_activities.map{ |activity| activity.full_set }.flatten
  end

end

