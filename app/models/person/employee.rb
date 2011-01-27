class Person::Employee < ActiveRecord::Base

  set_table_name ('person_employees')
  include Appointable

  def appointable_id
    self.payroll_number
  end

  def self.find_by_appointable_id(id)
    self.find_by_payroll_number( id )
  end

  def self.store_row_hash( row_hash )
    self.create( row_hash )
  end

  def self.prepare_table_for_stores()
    self.delete_all
  end

end
