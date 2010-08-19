class Spreadsheet::Administrators < Spreadsheet::Spreadsheet

  def self.headers
    [
      'Prefix','FirstName','MiddleName','LastName','Suffix',
      'Title',
      'CompanyName',
      'AddressLine1','AddressLine2',
      'City','State','Zip',
      'Phone','Email'
    ]
  end

  def self.load_records()
    self.column_key = {}
    self.headers.each_index{ |index| 
      self.column_key[index] = headers[index].underscore
    }
    end_of_list= false

    self.each_row { |spreadsheet,row|
      row_hash= {}
      self.headers.each_index{ |index| 
        row_hash[ self.headers[index].underscore ] = spreadsheet.cell(row,index+1)
      }
      end_of_list= true if row_hash[:last_name] == nil
    }
  end

  def self.load_record_file(filename)
    self.spreadsheet = nil
    self.filename = filename
    self.open
    self.load_records()
    self.spreadsheet
  end

  def self.load_data_records()
    self.load_recordfile( File.join( RAILS_ROOT, "data" , "ADMINISTRATORS.ods") )
  end

end
