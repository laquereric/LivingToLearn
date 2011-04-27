class AddCurrentMarketingContextToUser < ActiveRecord::Migration
  def self.up
    add_column "users", :current_marketing_context , :string , :default => ""
  end

  def self.down
    remove_column "users",:current_marketing_context
  end
end
