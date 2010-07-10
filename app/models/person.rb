class Person < Entity
  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_each :name do |record, attr, value|
      record.errors.add attr, 'has name attr' if not( value.nil? )
  end
end
