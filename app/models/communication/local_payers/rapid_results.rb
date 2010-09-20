class Communication::LocalPayers::RapidResults < Communication::Communication
  attr_accessor :first
  attr_accessor :last

  def initialize(params)

    self.first= params[:first]
    self.last= params[:last]

  end

  def get_dataset

    super
    self.dataset.common_hash={}
    self.dataset.record_hash_array= self.payer_hash_array

  end

  def transform_row(r)
    r[:prospect_id]= r[:prospect_id].to_i.to_s
    return r
  end

  def use_row?(row_hash)
    true
  end

  def payer_hash_array

    Person::ParentPotentialPayer.all[self.first..self.last].map{|pyr| pyr.get_flat_hash}
    #.select{ |rh|
    #  use_row?(rh)
    #}
    #transformed_rows= rows.map{ |raw_row|
    #  transform_row(raw_row)
    #}

  end

  def label(d)
    d.program= 'PotentialPayer'.underscore.to_sym
    d.name= 'Rapid'.underscore.to_sym
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
