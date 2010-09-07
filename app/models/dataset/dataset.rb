class Dataset::Dataset

  attr_accessor :record_hash_array
  attr_accessor :common_hash
  attr_accessor :merged_hash
  
  def initialize()
    self.common_hash= {}
    self.record_hash_array= []
   end

  def set_data(dataset)
    self.common_hash= dataset.common_hash
    self.record_hash_array= dataset.record_hash_array
  end
 
end
