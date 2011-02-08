class Person::Employee < ActiveRecord::Base

  set_table_name ('person_employees')
  include Appointable

  def abbrev
    r = 'e'
    r << '_ls' if self.lump_sum?
    r << '_ro' if self.records_only?
    return r
  end

  def mnemonic
    "#{self.last_name}_#{self.first_name}__Tutor_#{self.payroll_number.to_i}"
  end

  def self.id_from_mnemonic(mnemonic)
    if mnemonic.nil?
      p "nil mnemonic"
      return nil
    end
    a_name_aid = mnemonic.split('__')
    if a_name_aid.length == 0
      p "bad mnemonic #{mnemonic}"
      return nil
    end
    a_tutor_eid = a_name_aid[1].split('_')
    if a_tutor_eid.length == 0
      p "bad mnemonic #{mnemonic}"
      return nil
    end
    a_tutor_eid[1].to_f
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

  def records_only?
    return (!self.records_only.nil? and (self.records_only.downcase == 'y') )
  end

  def lump_sum?
    return (!self.lump_sum.nil? and (self.lump_sum.downcase == 'y') )
  end

end
