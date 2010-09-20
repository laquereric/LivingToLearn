class Person::Person < Entity

  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_each :name do |record, attr, value|
      record.errors.add attr, 'has name attr' if not( value.nil? )
  end

  def self.fields_used
    [:prefix,:first_name,:middle_name,:last_name,:suffix]
  end

  def self.get_name_hash(hash)
    name_hash= {}
    self.fields_used.each{ |field|
      name_hash[field]= hash[field]
    }
    return name_hash
  end

end
