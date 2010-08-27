class Merge::Letter < Merge::Merge

  def self.type_symbol
    return :letter
  end

  def list_symbols
    [:name_and_address_list]
  end

end
