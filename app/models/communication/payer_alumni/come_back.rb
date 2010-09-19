class Communication::PayerAlumni::ComeBack < Communication::Communication

  attr_accessor :school_district
  attr_accessor :postcards_series

  def get_dataset
    super
    self.dataset.common_hash={}
    self.dataset.record_hash_array=
      self.payer_clients_hash()
  end

  def enough_data(row_hash)
    return false if row_hash.nil?
    r= ( !row_hash[:address_line1].nil? and
      !row_hash[:city].nil? and
      !row_hash[:state].nil? and
      !row_hash[:zip].nil? )
    return r
  end

  def use_row?(row_hash)
    ( enough_data(row_hash) and !row_hash.nil? and !row_hash[:select].nil? and ( row_hash[:select].strip.length > 0) )
  end

  def strip_row(row_hash)
    row_hash.delete(:last_call)
    row_hash.delete(:phone1)
    row_hash.delete(:phone2)
    row_hash.delete(:tutor)
    row_hash.delete(:school)
    row_hash.delete(:email)
    row_hash.delete(:school_teacher)
    row_hash.delete(:student_dob)
    row_hash[:client_id]= row_hash[:client_id].to_i.to_s
    row_hash[:payer_id]= row_hash[:payer_id].to_i.to_s
    row_hash
  end

  def payer_clients_hash
    spreadsheet= Spreadsheet::Payers.new()
    set= spreadsheet.class.record_hash_array.select{ |rh|
      use_row?(rh)
    }
    stripped= set.map{ |row_hash|
      strip_row(row_hash)
    }
    return stripped
  end

  def label(d)

    d.program= 'PayerAlumni'.underscore.to_sym
    d.name= 'ComeBack'.underscore.to_sym
    d

  end

  def set_data(d)
    d.set_data(self.dataset)
    d
  end

  def get_postcards_series
    d= Document::PostcardsSeries.new()
    label( d )
    set_data( d )
  end

  def produce
    init_tmp_dir()
    get_dataset
    m= get_postcards_series
    save_merge( m.type , m.path, m.csv_content )
  end

end
