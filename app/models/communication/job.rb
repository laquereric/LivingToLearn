class Communication::Job
  #set_table_name :communication_jobs
  attr_accessor :id_offset

  def self.set_size
    333
  end

  def self.sets(&block)
    done= false
    last_id= 0
    while !done do
      done,last_id= yield( last_id, self.set_size )
    end
  end

end
