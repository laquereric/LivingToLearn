class Activity < ActiveRecord::Base
  belongs_to :user
  has_many :time_logs
end

