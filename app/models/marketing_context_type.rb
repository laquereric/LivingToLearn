class MarketingContextType < ActiveRecord::Base
  def self.all_except(list)
    self.all.select{ |mct| !list.include?(mct) }
  end
end
