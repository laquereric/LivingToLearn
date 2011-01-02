class Person::Employee < ActiveRecord::Base

  set_table_name ('person_employees')

  def self.store_row_hash(row_hash)
    self.create(row_hash)
  end

  def self.prepare_table_for_stores()
    self.delete_all
  end

end
