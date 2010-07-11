class Government < Entity
  validates_presence_of :name
  validates_each :first_name , :last_name do |record, attr, value|
      record.errors.add attr, "has #{attr} attr" if not( value.nil? )
  end
end
