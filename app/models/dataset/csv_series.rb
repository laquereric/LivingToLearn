class Dataset::Csv_3x < Dataset::Csv

  attr_accessor :offset_records

  def prefix(offset,record_hash)
    r={}
    record_hash.each_pair{ | k, v |
      rk="r#{offset}_#{k.to_s}".to_sym
      r[rk]=v
    }
    r
  end

  def record_merge(record_number,record_hash,common_hash)
    offset_records=[] if offset_records.nil?
    offset = record_number & 3
    offset_records[seq]= prefix(offset,record_hash)
    r= case offset
      when 0 , 1: nil
      when 2 : 
        r= {}
        offset_records.each{ |h|
          r.merge!(h)
        }
        r.merge(common_hash)
        offset_records= []
    endi
  end

end
