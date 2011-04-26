class MarketingContext < ActiveRecord::Base
  belongs_to :user
  belongs_to :marketing_context_type
end
