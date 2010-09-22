class Communication::LocalPayers::RapidResults < Communication::Communication

  attr_accessor :first
  attr_accessor :count

  def self.produce_all
    Communication::Job.sets{ |first_id,set_size|
      c= self.new( { :first => first_id, :count => set_size } )
      c.produce
      count= c.dataset.record_hash_array.length
      p "Starting at record id: #{first_id} count: #{count} filename: #{c.filename}"
      done= ( count < set_size )
      last_id= if count > 0 then c.dataset.record_hash_array[-1][:prospect_id] else 0 end
      [done,last_id]
    }
  end

  def initialize(params)

    self.first= params[:first]
    self.count= params[:count]

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
    record_set= Person::ParentPotentialPayer.next_set(self.first,self.count)
    hash_array= record_set.map{ |pyr| pyr.get_flat_hash }
    return hash_array

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
