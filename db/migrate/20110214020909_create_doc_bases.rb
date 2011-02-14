class CreateDocBases < ActiveRecord::Migration
  def self.up
    create_table :doc_bases do |t|
      t.string :name
      t.boolean :exclusive

      t.timestamps
    end
  end

  def self.down
    drop_table :doc_bases
  end
end
