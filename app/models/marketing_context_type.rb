require 'csv'

class MarketingContextType < ActiveRecord::Base
  def self.all_except(list)
    self.all.select{ |mct| !list.include?(mct) }
  end
##########
#
###########

  def self.filename
    File.join(Rails.root,'data','marketing_context_types.csv')
  end

  def self.all_to_csv
    MarketingContextType.all.map{ |r| r.name }
  end

  def self.all_to_data_file
    File.open(self.filename,'w'){|f| 
      self.all_to_csv.each{ |l|
        f.puts(l)
      }
    }
  end

  def self.each_csv_row
    line_number = 0
    CSV::Reader.parse(File.open(self.filename, 'rb')) do |row|
      yield(line_number,row )
      line_number +=1
    end
  end

  def self.raw_csv_data
    rs = []
    self.each_csv_row{ |line_number,row|
      rs << row
    }
    return rs
  end

  def self.load_from_data
    raw_csv_data.each{ |l|
      name = l[0]
      r = self.find_by_name(name)
      next if r
      self.create({:name=>name})
      p "Added #{name}"
    }
  end

end
