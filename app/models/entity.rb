class Entity < ActiveRecord::Base

  has_many :entity_details

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
    entity_detail= EntityDetail.create({:entity=>self,:detail=>detail})
    self.entity_details<< entity_detail
    return detail
  end

  def self.add_entity(type,params)
    entity= self.create( self.include_entity_params(params) )
    entity.add_detail( type, self.exclude_entity_params(params) )
    return entity
  end

end
