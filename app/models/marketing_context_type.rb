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

  def to_csv
    [ self.order, self.name, self.prompt, self.service_type_list ].join(',')
  end

  def self.all_to_csv
    MarketingContextType.all.map{ |r|
      r.to_csv
    }
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

  def self.load_from_data_file
    raw_csv_data.each{ |l|
      name = l[1]
      r = self.find_by_name(name)
      next if r
      self.create({
        :order => l[0],
        :name => name,
        :prompt => l[2],
        :service_type_list => l[3]
      })
      p "Added #{name}"
    }
  end

###################

  def best_prompt
    r = if !self.prompt.nil? and self.prompt.length > 0 then self.prompt else "If you are a #{self.name}" end
    return r
  end

end
