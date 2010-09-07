class Dataset::Csv < Dataset::Dataset
 
  attr_accessor :header_symbols
  attr_accessor :header_titles
  attr_accessor :output

  def set_data(dataset)
    super
    set_header_symbols_from_hash
    set_header_titles_from_symbols
    self
  end

  def record_merge(record_number,record_hash,common_hash)
    record_hash.merge(common_hash)
  end

  def get_merged_hash()
    record_number= 0
    self.merged_hash= record_hash_array.map{ |record_hash|
      m= record_merge(record_number,record_hash,self.common_hash)
      record_number+= 1
      m
    }
  end

  def set_header_symbols_from_hash
    self.header_symbols= [
      self.record_hash_array[0].keys.sort{ |x,y| x.to_s <=> y.to_s },
      self.common_hash.keys.sort{ |x,y| x.to_s <=> y.to_s }
    ].flatten
  end

  def set_header_titles_from_symbols
    self.header_titles= self.header_symbols.map{ |hs| hs.to_s.camelcase }
  end

  def get_output_header
    self.header_titles.join(',')
  end

  def get_output_field(val)
    r= if !val.nil? then "\"#{val.to_s.strip}\"" else "\"\"" end
    r
  end

  def get_output_record(rec)
    r= self.header_symbols.map{ |sy| 
      r= get_output_field( rec[sy] )
      r= get_output_field( self.common_hash[sy] ) if r.nil?
      r
    }.join(',')
    r
  end

  def get_output_records()
    r= self.get_merged_hash().map{ |rec| 
      get_output_record(rec) 
    }.join("\n")
    r
  end

  def get_output
    csv= ""
    csv << get_output_header()
    csv << "\n"
    csv << get_output_records()
    csv << "\n"
    csv
  end

end
