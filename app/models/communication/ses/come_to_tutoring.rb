class Communication::Ses::ComeToTutoring < Communication::Communication

  def get_dataset

    super
    self.dataset.common_hash={}
    self.dataset.record_hash_array=
    self.ses_clients_hash()

  end

  def transform_row(rr)
    r= rr.dup

    r[:prefix]=
    r[:first_name]= rr[:parent_xx_first_name]
    r[:middle_name]= rr[:parent_xx_middle_name]
    r[:last_name]= rr[:parent_xx_last_name]
    r[:suffix]= rr[:parent_xx_suffix]

    r[:prefix]
    r[:student_first_name]= rr[:first_name]
    r[:student_middle_name]= rr[:middle_name]
    r[:student_last_name]= rr[:last_name]
    r[:suffix]= rr[:suffix]
    return r
 end

  def use_row?(row_hash)
    r= (!row_hash.nil? and !row_hash[:select].nil? and ( row_hash[:select].strip.length > 0) )
    return r
  end

  def ses_clients_hash

    spreadsheet= Spreadsheet::CurrentClients.new()
    rows= Spreadsheet::CurrentClients.record_hash_array.select{ |rh|
      use_row?(rh)
    }
    transformed_rows= rows.map{ |raw_row|
      transform_row(raw_row)
    }

  end

  def label(d)

    d.program= 'Ses'.underscore.to_sym
    d.name= 'ComeToTutoring'.underscore.to_sym
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
