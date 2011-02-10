class AddTestScoresToClients < ActiveRecord::Migration
  def self.up
    add_column :person_clients, :map_spring,:string
    add_column :person_clients, :cat_5_vocabulary,:string
    add_column :person_clients, :cat_5_comprehension,:string
    add_column :person_clients, :cat_5_grammar,:string
    add_column :person_clients, :cat_5_punctuation,:string
  end

  def self.down
    remove_column :person_clients, :map_spring
    remove_column :person_clients, :cat_5_vocabulary
    remove_column :person_clients, :cat_5_comprehension
    remove_column :person_clients, :cat_5_grammar
    remove_column :person_clients, :cat_5_punctuation
  end
end
