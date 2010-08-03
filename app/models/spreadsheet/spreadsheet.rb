require "roo"

class Spreadsheet::Spreadsheet

  cattr_accessor :filename
  cattr_accessor :spreadsheet

  cattr_accessor :raw_column_key
  cattr_accessor :column_key

  cattr_accessor :lookup_cache

  def self.purge
  end

  def self.open
    if self.spreadsheet.nil?
      ext= self.filename.split('.')[1]
      #self.spreadsheet = Openoffice.new(self.filename) if self.spreadsheet.nil?
      self.spreadsheet = Openoffice.new(self.filename) if ext == 'ods'
      self.spreadsheet = Excel.new(self.filename) if ext == 'xls'
      self.spreadsheet = Excel.new(self.filename) if ext == 'gss'
    end
    #p self.spreadsheet.to_s
    self.spreadsheet
  end

  def self.close
     self.spreadsheet = nil
  end

  def self.each_header(&block)
    if (s = self.open)
#debugger
     #p "loaded!"
      column = 1
      self.raw_column_key = {}
      while not( content = s.cell(1,column) ).nil?
        #p content.inspect
        yield(column,content) if block_given?
        raw_column_key[column] = content
        column += 1
      end
      p column_key.inspect
    end
  end

  def self.convert_header()
    self.column_key = {}
    self.raw_column_key.each_pair{ |col,header|
      self.column_key[col] = header.gsub(' ','').underscore
    }
  end

  def self.each_record(&block)
      row = 2
      end_of_list = false
      while not( end_of_list )
        row_content = {}
        end_of_list = true
        self.column_key.each_pair{ |col,field|
          row_content[field] = ( content = self.spreadsheet.cell(row,col) )
p "row: #{row} col: #{col} field: #{field} content: #{content}"
          end_of_list =  false if end_of_list and !content.nil?
        }
        yield(row,row_content)  if not(end_of_list)
        row += 1
      end
  end

end
