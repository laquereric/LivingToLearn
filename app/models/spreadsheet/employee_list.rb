class Spreadsheet::EmployeeList < Spreadsheet::Spreadsheet

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
      r[ employee[:payroll_number].to_i]= employee
    }
    return r
  end

  def initialize()
    self.class.record_hash_array= Rails.cache.read(self.class.cache_name)
  end

  def google_path
    File.join( 'TutoringClub', 'Data', 'Clients', self.google_filename )
  end


  def self.headers

    [
'Select',
'To Do',
'PayrollNumber',
'ParentPayrollNumber',
'Prefix',
'FirstName',
'Nickname',
'MiddleName',
'LastName',
'Suffix',
'Extension',
'Title',
'Home Email',
'Email',
'Phone1',
'Phone2',
'Phone3',
'W4',
'NjTax',
'NjCriminal'
]
  end

end

