class EducationalResource < ActiveRecord::Base

  def record_id
    id
  end

  def source
    'unknown'
  end

  def self.worksheet_directory
    File.join(Rails.root,'data','worksheets')
  end

  def self.get_worksheet_full_filenames
    Dir.glob( File.join( worksheet_directory,'**','*') )
  end

  def self.get_worksheet_paths
    get_worksheet_full_filenames.map{ |fn|
      after_worksheet_level = false
      fn.split('/').map{ |n|
        r = if after_worksheet_level then n else nil end
        after_worksheet_level = true if n == 'worksheets'
        r
      }.compact.join('/')
    }
  end

  def self.update_db
    added = 0
    self.get_worksheet_paths.each{ |wsp|
      t = self.find_by_filepath(wsp)
      next if !t.nil?
      added += 1
p wsp
      self.create({
        :filepath => wsp
      })
    }
p "added #{added}"
    return added
  end

end
