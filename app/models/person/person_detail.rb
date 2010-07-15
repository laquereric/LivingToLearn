class Person::PersonDetail < Detail
  belongs_to :person, :foreign_key => :entity_id
end
