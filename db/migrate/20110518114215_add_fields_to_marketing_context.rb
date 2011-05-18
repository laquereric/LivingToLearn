class AddFieldsToMarketingContext < ActiveRecord::Migration
  def self.up
    add_column "marketing_context_types", :prompt , :string
    add_column "marketing_context_types", :service_type_list , :text
    add_column "marketing_context_types", :order , :integer
  end

  def self.down
    remove_column "marketing_context_types", :prompt
    remove_column "marketing_context_types", :service_type_list
    remove_column "marketing_context_types", :order
  end
end
