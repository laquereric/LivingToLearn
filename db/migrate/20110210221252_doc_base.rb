class DocBase < ActiveRecord::Migration

  def self.up
    create_table "doc_bases", :force => true do |t|
      t.string "filename"
      t.text "meta"
    end
  end

  def self.down
    drop_table "doc_bases"
  end

end
