class Government::State < Government::GovernmentDetail
  set_table_name :government_states
  #named_scope :named_joe, :include => :government, :conditions => [ "government.name = ?", 'Joe' ]
end
