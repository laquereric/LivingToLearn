class AddMessageToMarketingContextType < ActiveRecord::Migration
  def self.up
    add_column "marketing_context_types", :message, :text
    add_column "marketing_context_types", :title, :string
  end

  def self.down
    remove_column "marketing_context_types", :message
    remove_column "marketing_context_types", :title
  end
end
