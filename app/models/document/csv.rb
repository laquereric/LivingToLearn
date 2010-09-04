class Document::Csv
  attr_accessor :header_symbols
  attr_accessor :header_titles
  attr_accessor :record_hash_array
  attr_accessor :output

  def set_header_symbols_from_hash
    self.header_symbols= self.record_hash_array[0].keys
  end

  def set_header_titles_from_symbols
    self.header_titles= self.header_symbols.map{ |hs| hs.to_s.camelcase}
  end

  def get_output
    csv= ""
    csv << self.header_titles.join(',')
    csv << "\n"
    csv << self.record_hash_array.map{|rec| rec.values}.join(',')
    csv << "\n"
    csv
  end


end
