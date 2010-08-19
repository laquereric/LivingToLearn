class Person::PersonDetail < Detail
  belongs_to :person, :foreign_key => :entity_id
  def self.entity_class
    Person::Person
  end

end
