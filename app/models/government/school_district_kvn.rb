require 'csv'
class Government::SchoolDistrictKvn < ActiveRecord::Base

  set_table_name :government_school_district_kvns

  has_many :schools,
    :class_name => 'Government::SchoolK6',
    :foreign_key => "government_district_id",
    :dependent => :destroy

###############
# Lower Level
###############
  def self.filename
    File.join(Rails.root,'data','gloucester_nj_districts.csv')
  end

  def self.clean_row(row)
    [0..header_symbols.length].each{ |col_num|
      row[col_num] = nil if !row[col_num].nil? and row[col_num].to_s.gsub(' ','').length == 0
    }
    return row
  end

  def self.each_csv_row
    line_number = 0
    CSV::Reader.parse(File.open(self.filename, 'rb')) do |row|
      yield(line_number,self.clean_row(row) )
      line_number +=1
    end
  end

#######
#
#######

  def self.raw_csv_data
    rs = []
    self.each_csv_row{ |line_number,row|
      rs << row
    }
    return rs
  end

#######
#
#######

  def self.header_list
    strings = <<-eos
      Code
      Name
      Nickname
      Chief School Administrator
      Phone Numbers
      Chief Administrator Email
      Web
      Address 1
      Address 2
      City
      State
      Zip
      Chief Secretary
      Chief Secretary Phone
    eos
    return strings.split("\n").map{ |st| st.strip }
  end

  def self.header_symbols
    self.header_list.map{|n| n.downcase.gsub(' ','_').to_sym}
  end

  def self.row_hash(row)
    h = {}
    (0..self.header_symbols.length).each{ |i|
      k = self.header_symbols[i]
      h[ k ] = row[i]
    }
    return h
  end

###########
#
###########

  def self.csv_data
    rs=[]
    self.each_csv_row{ |line_number,row|
      next if line_number == 0
      rs<< row_hash(row)
    }
    return rs
  end

  def self.purge
    self.delete_all
  end

###########
#
###########
  def self.to_records
    self.csv_data.each{ |h|
      next if h[:nickname].nil?
      h.delete(nil)
      n = self.create(h)
    }
  end

end
