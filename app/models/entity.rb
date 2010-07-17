class Entity < ActiveRecord::Base

  has_many :entity_details
  #has_many :details, :through => :entity_details
  named_scope :named, lambda { |name| {:conditions => ["name = ?", name ] } }
  named_scope :with_id, lambda { |name| {:conditions => ["id = ?", object_id ] } }

  def self.find_by_type(t)
    EntityDetail.with_detail_type(t).map{ |ed| ed.entity }
  end

  def details
    EntityDetail.with_entity_id(self.id).map{ |ed| ed.detail}
  end

  def details_of_type(t)
    EntityDetail.with_entity_id(self.id).select{ |ed| ed.detail_type == t}.map{ |ed| ed.detail}
  end

  #named_scope :with_entity_detail_typed, lambda { |t| { 
  #  :include => :entity_details, :conditions => ["entity_details.detail_type = ?", t] 
  #} }

  #school_district_detail= school_district_rec.
  #named_scope :entity_details_of_type lambda { |name| {:conditions => ["name = ?", name ] } }


#(Government::SchoolDistrict)[0].detail

  def self.fields_used
    [:prefix,:first_name,:middle_name,:last_name,:suffix,:name]
  end

  def self.include_entity_params(params)
    result= {}
    self.fields_used.each{ |pn|
      result.merge!( { pn => params[pn] } ) if params[pn]
    }
    return result
  end

  def self.exclude_entity_params(params)
    result= params.dup
    self.fields_used.each{ |pn|
      result.delete( pn )
    }
    return result
  end

  def add_detail (type,params)
    detail= type.create( self.class.exclude_entity_params(params).merge!({ :entity_id => self.id }) )
    entity_detail= EntityDetail.create({:entity => self, :detail_id => detail.id , :detail_type => detail.class.to_s })
    self.entity_details<< entity_detail
    return self.entity_details.map{ |ed| ed.detail }.compact
  end

  def self.add_entity_detail(type,params)
    entity= self.create( self.include_entity_params(params) )
    details= entity.add_detail( type, self.exclude_entity_params(params) )
    return entity, details
  end

end
