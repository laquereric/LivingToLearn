class Spreadsheet::LivingToLearn::PotentialKvnSponsor < Spreadsheet::SpreadsheetTable

  set_table_name ('spreadsheet__living_to_learn__potential_kvn_sponsors')

  def self.clean_sic_description(sic_des)
    return nil if sic_des.nil? or sic_des.length == 0
    return sic_des.gsub("\/","").gsub("\'",'').gsub('&','').gsub('(','').gsub(')','').gsub(',','').gsub(' ','').gsub(' ','').underscore.to_sym
  end

  def sic_description_symbols
    raw = [ :primary_sic_description, :secondary_sic_description_1, :secondary_sic_description_2 ].map{ |fs|
      val = self.send(fs)
    }.select{ |v| !v.nil? and v.length > 0 }.map{ |v| self.class.clean_sic_description(v) }
  end

  def self.histogram
    hist = {}
    self.all.each{ |pt|
      pt.sic_description_symbols.each{ |sic_description_symbol|
         hist[sic_description_symbol] = [] if hist[sic_description_symbol].nil?
         hist[sic_description_symbol] << pt
      }
    }
    return hist
  end

  def self.print_histogram
    self.histogram.to_a.sort{ |x,y| x[0].to_s <=> y[0].to_s }.each{ |a|
      k = a[0]
      v = a[1]
      p "#{k} => #{v.length}"
    }
    p "count: #{self.count}"
    return nil
  end

end

