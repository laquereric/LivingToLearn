class Spreadsheet::MlmSplit < Spreadsheet::Spreadsheet

############
#
############
  def initialize()
    self.class.record_hash_array= Rails.cache.read(self.class.cache_name)
  end

  def google_path
    File.join( 'TutoringClub', 'Finance', self.google_filename )
  end

  def self.headers
    [
      'Type',
      'Depth',
      'Split 1',
      'Split 2',
      'Split 3',
      'Split 4',
      'Split 5',
      'Split 6'
    ]
  end
  def self.clean_row_hash(row_hash)
    row_hash[:depth]= row_hash[:depth].to_i
    return row_hash
  end

####################
#
#####################
  def self.hash
    r= {}
    Spreadsheet::MlmSplit.cache_dump.each{ |split|
p r
p split
      r[ split[:depth] ]= {} if  r[ split[:depth] ].nil?
      r[ split[:depth] ][ split[:type].to_sym ]= split
    }
    return r
  end

end

