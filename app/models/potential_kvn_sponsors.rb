class PotentialKvnSponsors < ActiveRecord::Base

  require 'csv'
  cattr_accessor :raw_csv_headers
  cattr_accessor :field_csv_headers

  scope :all_public, lambda {
     where("potential_kvn_sponsors.actual_sales_volume = 0")
  }

  scope :all_private, lambda {
     where("potential_kvn_sponsors.actual_sales_volume > 0")
  }

  def self.municipalities
    self.all.map{|r| r.city}.uniq
  end

#########################
# CSV Import methods
##########################

  def self.filename
    File.join(Rails.root,'data','potential_kvn_sponsors.csv')
  end

  def self.row2hash(row)
    hash = {}
    self.field_csv_headers.each_index{ |i|
      hash[ field_csv_headers[i] ] = row[i]
    }
    return hash
  end

  def self.get_records_from_csv
    line_number = 0
    rs = []
    CSV::Reader.parse(File.open(self.filename, 'rb')) do |row|
      if line_number == 0
        self.raw_csv_headers = row
        self.field_csv_headers = row.map{ |n| n.gsub('/','').gsub(' ','').underscore }
      else
        rs << self.create( row2hash(row) )
      end
      line_number +=1
    end
    return rs
  end

#########################
# utility
##########################

  def zip_code_5
    return zip_code.split('-')[0].to_i
  end

  def self.uniq_zip_codes
    PotentialKvnSponsors.all.map{ |s| s.zip_code_5 }.uniq
  end
end

