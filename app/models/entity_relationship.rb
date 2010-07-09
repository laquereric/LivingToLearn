class EntityRelationship < ActiveRecord::Base

  belongs_to :from, :class_name => 'Entity', :foreign_key => :from
  belongs_to :to, :class_name => 'Entity', :foreign_key => :to

  #validates_presence_of :from_id
  validates_presence_of :from
  validates_associated :from
  validates_presence_of :to
  validates_associated :to

  #validates_presence_of :to_id

end
