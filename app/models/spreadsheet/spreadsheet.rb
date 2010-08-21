require "roo"

class Spreadsheet::Spreadsheet

  cattr_accessor :filename
  cattr_accessor :spreadsheet

  cattr_accessor :raw_column_key
  cattr_accessor :column_key

  cattr_accessor :lookup_cache

  def self.purge
  end

  def self.headers
    [
    ]
  end

  def self.check_headers
    ok = true
    Spreadsheet::Administrators.headers.each_index{ |index|
      actual = self.spreadsheet.cell(1,index+1) 
      expected = self.headers[index]
      if actual != expected
        p "expected: #{expected} actual: #{actual}"
        ok = false
      end
    }
    return ok
  end

  def self.open
    if self.spreadsheet.nil?
      name,ext= self.filename.split('.')
      self.spreadsheet = Openoffice.new(self.filename) if ext == 'ods'
      self.spreadsheet = Excel.new(self.filename) if ext == 'xls'
      if ext == 'gxls'
        file= GoogleApi::Document.find(self.filename)
        key = /spreadsheet:(.*)/.match(file.id)[1]
        self.spreadsheet = Google.new(key) 
      end
    end
    ok= self.check_headers
    if !ok
      p "Spreadsheet Header mismatch in #{self.filename}"
    end
    self.spreadsheet
  end

  def self.close
     self.spreadsheet = nil
  end

  def self.each_header(&block)
    if (s = self.open)
      column = 1
      self.raw_column_key = {}
      while not( content = s.cell(1,column) ).nil?
        #p content.inspect
        yield(column,content) if block_given?
        raw_column_key[column] = content
        column += 1
      end
#p column_key.inspect
    end
  end

  def self.convert_header()
    self.column_key = {}
    self.raw_column_key.each_pair{ |col,header|
      self.column_key[col] = header.gsub(' ','').underscore
    }
  end

  def self.each_row(&block)
      row = 2
      end_of_list = false
      while not( end_of_list )
        row_content = {}
        end_of_list= yield( self.spreadsheet, row )
        row += 1
      end
  end

  def self.each_record(&block)
      row = 2
      end_of_list = false
      while not( end_of_list )
        row_content = {}
        end_of_list = true
        self.column_key.each_pair{ |col,field|
          row_content[field] = ( content = self.spreadsheet.cell(row,col) )
          end_of_list =  false if end_of_list and !content.nil?
        }
        yield(row,row_content)  if not(end_of_list)
        row += 1
      end
  end

end
