require 'csv'

class MarketingContextType < ActiveRecord::Base
  serialize :service_type_list

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
    [ self.order, self.name, self.prompt, self.title, "\"#{self.service_type_list.inspect.gsub("\"","\'")}\"", self.message ].join(',')
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
    raw_csv_data.each_index{ |i|
      next if i == 0
      l = raw_csv_data[i]
      name = l[1]
      r = self.find_by_name(name)
      next if r
      service_type_list = eval(l[4]) if l[4]
      self.create({
        :order => l[0],
        :name => name.downcase,
        :prompt => l[2],
        :title => l[3],
        :service_type_list => service_type_list,
        :message => l[5]
      })
      p "Added #{name}"
    }
  end

  def self.replace_with_data_file
    self.delete_all
    self.load_from_data_file
  end


###################

  def best_prompt
    r = if !self.prompt.nil? and self.prompt.length > 0 then self.prompt else "If you are a #{self.name}" end
    return r
  end

end
