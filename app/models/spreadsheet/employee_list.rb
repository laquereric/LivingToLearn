class Spreadsheet::EmployeeList < Spreadsheet::Spreadsheet

#############
# Reflection of Spreadsheet in Object
#############

  def self.connected_object
    Person::Employee
  end

############
#
############

   def self.cache_name
     'employee_list'
   end

####################
#
#####################

 def self.each_employee
    ss= self.new
    client_array= ss.class.record_hash_array
    client_array.each{ |employee|
      yield(employee)
    }
  end
#
  def self.employee_hash
    r= {}
    self.each_employee{ |employee|
      r[ employee[:payroll_number].to_i ]= employee
    }
    return r
  end

  def initialize()
    self.class.record_hash_array= Rails.cache.read(self.class.cache_name)
  end

  def google_path
    File.join( 'TutoringClub', 'Data', 'Clients', self.google_filename )
  end

end

