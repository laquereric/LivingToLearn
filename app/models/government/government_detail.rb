class Government::GovernmentDetail < Detail

  belongs_to :government, :class_name => 'Entity', :foreign_key => :entity_id
  named_scope :named, lambda { |name| { :include => :government, :conditions => ["entities.name = ?", name] } }

  def self.purge
    Government::Country.delete_all
    Government::State.delete_all
    Government::County.delete_all
    Government::TownshipBoro.delete_all
    Government::Neighborhood.delete_all
    Government::SchoolDistict.delete_all
    Government::EntityDetail.delete_all
  end

  def self.add(attrs)
    Government::Government.add_entity( self, attrs )
  end

  def self.find_by_name_and_details( name, details )
    results= self.named(name).find( :all, :conditions => details )
    results[0]
  end

  def self.find_or_add_name_details( name, unique_details={}, other_details={} )
    rec= nil
    if ( rec = self.find_by_name_and_details( name , unique_details ) ).nil?
p 'new'
      rec = self.add( { :name => name }.merge( unique_details).merge( other_details) )
    else
p 'old'
    end
    return rec
  end

end
