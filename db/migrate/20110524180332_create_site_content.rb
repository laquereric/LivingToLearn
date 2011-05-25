class CreateSiteContent < ActiveRecord::Migration
  def self.up
    add_column :users, :avatar_file_name,    :string
    add_column :users, :avatar_content_type, :string
    add_column :users, :avatar_file_size,    :integer
    add_column :users, :avatar_updated_at,   :datetime

    create_table "site_contents", :force => true do |t|
      t.text       :html
      t.string     :type
      t.text       :search_terms
      t.string     :image_file_name
      t.string     :image_content_type
      t.string     :image_file_size
      t.datetime   :image_updated_at
      t.datetime   "created_at"
      t.datetime   "updated_at"
    end
  end

  def self.down
    remove_column :users, :avatar_file_name
    remove_column :users, :avatar_content_type
    remove_column :users, :avatar_file_size
    remove_column :users, :avatar_updated_at
    drop_table "site_contents"
  end
end
