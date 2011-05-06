require 'csv'
class Government::SchoolK6 < ActiveRecord::Base

  set_table_name :government_school_k6s

  belongs_to :district,
    :class_name => 'Government::SchoolDistrictKvn',
    :foreign_key => "government_district_id",
    :dependent => :destroy

###############
# Lower Level
###############
  def self.filename
    File.join(Rails.root,'data','gloucester_nj_k6_schools.csv')
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
      District Code
      School Code
      Grades
      Name
      Nickname
      School Address
      School City
      School State
      School Zip
      Township
      School Web Site
      Principal Prefix
      Principal First Name
      Principal Last Name
      Principal Phone Number
      Principal Email
      Principal Notes
      Pto Contact A Prefix
      Pto Contact A First Name
      Pto Contact A Last Name
      Pto Contact A Phone Number
      Pto Contact A Email
      Pto Contact A Notes
      Pto Contact B Prefix
      Pto Contact B First Name
      Pto Contact B Last Name
      Pto Contact B Phone Number
      Pto Contact B Email
      Pto Contact B Notes
      Pto Notes
      Pto Web Site
      Num of Papers Distributed per School
      Total Num Of Papers Distributed per Township
      Where Papers Were Delivered
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

###########
#
###########
  def district_by_code
    Government::SchoolDistrictKvn.find_by_code(self.district_code)
  end

  def connect_district
    district = self.district_by_code
    if district
      self.government_district_id = district.id
      self.save
    else
        p "District not found for  #{school.name} district_code: #{school.district_code}"
    end
  end

  def self.to_records
    self.csv_data.each{ |h|
      h.delete(nil)
      school = self.create(h)
    }
  end

end
