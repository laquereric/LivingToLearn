class Dataset::CsvSeries < Dataset::Csv

  attr_accessor :offset_records

  def variable_header_symbols
    syms= super
    r= syms.map{ |sy|
      [prefix_symbol(0,sy),prefix_symbol(1,sy),prefix_symbol(2,sy)]
    }.flatten
    return r
  end

  def prefix_symbol(offset,k)
      rk="r#{offset}_#{k.to_s}".to_sym
  end

  def prefix(offset,record_hash)
    r= {}
    record_hash.each_pair{ | k, v |
      prefix_symbol(offset,k)
      #rk="r#{offset}_#{k.to_s}".to_sym
      rk= prefix_symbol(offset,k)
      r[rk]= v
    }
    r
  end

  def assemble_record()
    r= {}
    self.offset_records.each{ |h|
      r.merge!(h)
    }
    r.merge!(common_hash)
    offset_records= []
    r
  end

  def record_merge(record_number,record_hash,common_hash)
    self.offset_records=[] if offset_records.nil?
    offset = record_number % 3
    self.offset_records[offset]= prefix(offset,record_hash)
    r= case offset
      when 0 , 1: nil
      when 2 : assemble_record()
    end
    return r
  end

  def fill_out_with(record_hash)
    l= offset_records.length 
    return if l == 0
    return if l == 3
    for i in l..2 do
      offset_records<< prefix( l, record_hash )
    end
    assemble_record()
  end

  def get_merged_hash()
    super
    self.merged_hash<< fill_out_with( self.last_record )
    self.merged_hash.compact!
    self.merged_hash
  end

end
