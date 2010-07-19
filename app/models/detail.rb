class Detail < ActiveRecord::Base
  has_one :entity_detail, :foreign_key => :detail_id , :dependent => :destroy
  has_one :entity, :through=> :entity_detail

  belongs_to :entity
  validates_presence_of :entity
  validates_associated :entity

  def name
    self.entity.name
  end

  def self.entities
    Entity.find_by_type(self.to_s)
  end

  def self.add_entity_detail(attrs)
    self.entity_class.add_entity_detail( self, attrs )
  end

  def self.find_by_name_and_details( name, details )
    entity_details= self.named(name).find( :all, :conditions => details ).compact
    #TODO error check
    entity= if entity_details.length > 0 then entity_details[0].entity else nil end
    return entity, entity_details #.map{|ed| ed.detail}
  end

  def self.find_or_add_name_details( name, unique_details={}, other_details={} )
    rec= nil
    entity, details =
      self.find_by_name_and_details( name , unique_details )
    if entity.nil?
     entity, details =
       self.add_entity_detail( { :name => name }.merge( unique_details).merge( other_details) )
    end
    return entity, details
  end

end
