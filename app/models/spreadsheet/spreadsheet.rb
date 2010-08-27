require "roo"

class Spreadsheet::Spreadsheet

  cattr_accessor :filename
  cattr_accessor :spreadsheet

  cattr_accessor :raw_column_key
  cattr_accessor :column_key

  cattr_accessor :lookup_cache

  def self.spreadsheet_file_keys
    {
    :adminstrators => Spreadsheet::Administrators,
    :church_leaders => nil,
    :ptos => nil,
    :schools => nil,
    :guidance_counselors => nil
    }
  end

  def self.cursor_filename
    File.join( RAILS_ROOT, 'cursors','Spreadsheet' )
  end

  def self.set_cursor(key)
    text = {:spreadsheet_file_key => key}.to_yaml
    File.open(self.cursor_filename, 'w') { |f|
      f.write(text)
    }
  end

  def self.get_cursor
    cursor_file= File.open(self.cursor_filename, 'r')
    text= cursor_file.read
    hash= YAML.load(text)
    hash[:spreadsheet_file_key]
  end

  def self.purge
  end

  def self.headers
    nil
  end

  def self.check_headers
    ok = true
    return ok if self.headers.nil?
    self.headers.each_index{ |index|
      actual = self.spreadsheet.cell(1,index+1) 
      expected = self.headers[index]
      if actual != expected
        p "expected: #{expected} actual: #{actual}"
        ok = false
      end
    }
    return ok
  end

  def self.load_records()
    self.column_key = {}
    self.each_header{ |column,content|
p "column: #{column},content: #{content}"
    }
    self.each_row { |spreadsheet,row|
p "row: #{row}"
    }
  end

  def self.load_record_file(filename)
    self.spreadsheet = nil
    self.filename = filename
    self.load_records()
    self.spreadsheet
  end

  def self.csv_record_file(spreadsheet_filename,csv_filename)
    self.spreadsheet = nil
    self.filename = spreadsheet_filename
    self.open
    self.spreadsheet.to_csv(csv_filename)
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
