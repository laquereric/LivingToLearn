class Government::GovernmentDetail < Detail

  belongs_to :government, :foreign_key => :entity_id
  def self.add(attrs)
    Government::Government.add_entity( self, attrs )
  end

end
