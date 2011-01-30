class Person::Employee < ActiveRecord::Base

  set_table_name ('person_employees')
  include Appointable

  def mnemonic
    "#{self.last_name}_#{self.first_name}__Tutor_#{self.payroll_number.to_i}"
  end

  def self.id_from_mnemonic(mnemonic)
    mnemonic.split('__')[1].split('_')[1].to_f
  end

  def appointable_id
    self.payroll_number
  end

  def self.find_by_mnemonic(mnemonic)
    self.find_by_payroll_number( self.id_from_mnemonic(mnemonic) )
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

  def color
    "FF0000"
  end

end
