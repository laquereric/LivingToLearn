require "roo"

class Spreadsheet::Spreadsheet

  cattr_accessor :filename
  cattr_accessor :spreadsheet

  cattr_accessor :raw_column_key
  cattr_accessor :column_key

  cattr_accessor :lookup_cache

  cattr_accessor :record_hash_array

###################
#
###################

   def self.cache_dump
      Rails.cache.read(self.cache_name)
   end

   def self.cache_load
     ss= self.new
     ss.class.filename= ss.google_path
     record_hash_array= ss.class.load_record_hash_array
     Rails.cache.write(ss.class.cache_name, record_hash_array)
   end

#############
#
#############

  def self.purge
  end

  def self.headers
    nil
  end

  def self.header_match(actual,expected)
    return false if actual.nil?
    n_actual= actual.strip.gsub('_','').gsub(' ','')
    n_expected= expected.strip.gsub('_','').gsub(' ','')
    return n_actual == n_expected
  end

  def self.check_headers
    ok = true
    return ok if self.headers.nil?
    self.headers.each_index{ |index|
      actual = self.spreadsheet.cell(1,index+1)
      expected = self.headers[index]
      if !header_match(actual,expected)
        p "expected: #{expected} actual: #{actual}"
        ok = false
      end
    }
    return ok
  end

  def self.clean_row_hash(row_hash)
    row_hash
  end

  def self.use_row?(row_hash)
    true
  end

  def self.load_record_hash_array
p "load_record_hash_array"
     self.record_hash_array= []
    self.load_records{ |rh|
      clean_row= self.clean_row_hash(rh)
p rh.inspect
      record_hash_array<< clean_row if use_row?(clean_row)
    }
    self.record_hash_array
  end

  def self.key_for_header(header)
    header.gsub(' ','').underscore.to_sym 
  end

  def self.load_records(&block)
    self.column_key = {}
    self.each_header{ |column,content|
    }
    return if !block_given?
    self.each_row { |spreadsheet,row|
      row_hash= {}
      self.headers.each_index{ |i|
        val= spreadsheet.cell(row,i+1)
        val.strip! if !val.nil? and val.is_a? String
        row_hash[ key_for_header(self.headers[i]) ]= val
      }
      putc('.')
      end_of_list= (row_hash.values.compact.length == 0)
      yield(row_hash) if !end_of_list
      end_of_list
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
    if self.spreadsheet.nil?
      p "spreadsheet not found!"
    else
      self.spreadsheet.to_csv(csv_filename)
    end
  end

  def self.open
    if self.spreadsheet.nil?
      name,ext= self.filename.split('.')
      if ext == 'ods'
          self.spreadsheet = Openoffice.new(self.filename) 
      end
      if ext == 'xls'
        self.spreadsheet = Excel.new(self.filename)
      end
      if ext == 'gxls'
        file= GoogleApi::Document.find(self.filename)
        if file
          key = /spreadsheet:(.*)/.match(file.id)[1]
          self.spreadsheet = Google.new(key)
        else
          p "File #{self.filename} not found"
        end
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

  def self.normalize_header(h)
    r = if h.nil? then nil else h.gsub('_','').gsub(' ','') end
    return r
  end

  def self.each_header(&block)
    if (s = self.open)
      column = 1
      self.raw_column_key = {}
      while not( content = normalize_header(s.cell(1,column)) ).nil?
        yield(column,content) if block_given?
        raw_column_key[column] = content
        column += 1
      end
    else
      p "Could not open spreadshet #{self.filename}"
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

  def google_filename
    fn= self.class.to_s.split('::')[1]
    "#{fn}.gxls"
  end

  def self.clean_row_hash(row_hash)
    raw= row_hash[:zip]
    row_hash[:zip]= if raw.is_a? Integer then
      "_%.5i" % raw
    elsif raw.is_a? Float then
      "_%.5i" % raw.to_i
    else
      raw.to_s
    end
    row_hash
  end

########################
# Better I/F
########################

  def self.get_spreadsheet( filename )
    self.spreadsheet= nil
    self.filename= filename
    self.open
    return self.spreadsheet
  end

  def initialize(params)
  end

  def self.get_hash_array( filename )
    self.spreadsheet= nil
    self.filename= filename
    ss_object= self.new({})
    load_record_hash_array
    return ss_object.class.record_hash_array
  end

  def self.get_records( filename )
    self.spreadsheet= nil
    self.filename= filename
    ss_object= self.new({})
    load_record_hash_array
    return ss_object.class.record_hash_array
  end

  def self.store(filename)
    hash_array= get_hash_array( filename )
    hash_array.each{ |hash|
      self.store_hash(filename,hash)
    }
    self.identity_class.from_source(filename)
  end

################
#
################

  def self.test_google_ss
    return self.new
  end

end
