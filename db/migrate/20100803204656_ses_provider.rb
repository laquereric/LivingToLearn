class SesProvider < ActiveRecord::Migration
  def self.up
    create_table "organization_ses_provider", :force => true do |t|
      t.integer "ses_provider_id"
      t.integer "entity_id"
      t.text :contact
      t.text :areas_served
      t.text :services
      t.text :qualifications
    end
  end

  def self.down
    drop_table "organization_ses_provider"
  end
end
