class DocumentPdf < ActiveRecord::Migration
  def self.up
    create_table "document_pdfs", :force => true do |t|
      t.integer "entity_id"
      t.text  "tags"
      t.string  "filename"
    end
  end

  def self.down
    create_table "document_pdfs"
  end
end
