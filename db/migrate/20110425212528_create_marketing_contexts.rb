class CreateMarketingContexts < ActiveRecord::Migration
  def self.up

    create_table "marketing_contexts", :force => true do |t|
      t.string   "marketing_context_type_id"
      t.integer  "user_id"
    end

    create_table "marketing_context_types", :force => true do |t|
      t.string   "name"
    end

  end

  def self.down
    drop_table "marketing_context_types"
    drop_table "marketing_contexts"
  end

end
