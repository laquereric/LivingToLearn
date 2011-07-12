class Activity < ActiveRecord::Base
  belongs_to :user
  acts_as_nested_set :dependent => :destroy
  has_many :time_logs, :dependent => :destroy

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

