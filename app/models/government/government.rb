class Government::Government < Entity

  validates_presence_of :name

  validates_each :first_name , :last_name do |record, attr, value|
    record.errors.add attr, "has #{attr} attr" if not( value.nil? )
  end

  def self.fields_used
    [:name]
  end

end
