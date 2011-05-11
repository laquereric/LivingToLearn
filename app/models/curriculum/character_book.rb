class Curriculum::CharacterBook #< Curriculum::ParseCsv

  require 'csv'

############
# Lower Level
#############

  def self.filename
    File.join(Rails.root,'data','character_book.csv')
  end

  def self.content_area_key
    'CareersAdhoc'
  end

  def self.clean_row(row)
     [0..1].each{ |col_num|
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

  def self.show_csv_data
    self.each_csv_row{ |line_number,row|
      p row
    }
  end

  def self.parse_sub_task(sub_task)
    ar = sub_task.split(':')
    return { :kind => ar[0], :params => ar[1] }
  end

  def self.parse_task(script)
    return nil if script.nil?
    script.split('_').map{ |sub_task| parse_sub_task(sub_task) }
  end

  def self.csv_hashes
    rs = []
    self.each_csv_row{ |line_number,row|
      next if line_number == 0
      h = {}
      h[:task] = self.parse_task(row[0])
      h[:ref_type] = row[1]
      h[:ref] = row[2]
      rs<< h
    }
    return rs
  end


end

