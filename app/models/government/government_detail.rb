class Government::GovernmentDetail < Detail

  def self.entity_class
    Government::Government
  end

  belongs_to :government_entity, :class_name => 'Entity', :foreign_key => :entity_id
  named_scope :named, lambda { |name|
    { :include => :government_entity, :conditions => ["entities.name = ?", name] }
  }

  def self.purge
    Government::Country.delete_all
    Government::State.delete_all
    Government::County.delete_all
    Government::TownshipBoro.delete_all
    Government::Neighborhood.delete_all
    Government::SchoolDistrict.delete_all
    Government::EntityDetail.delete_all
  end

end
