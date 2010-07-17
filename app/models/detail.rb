class Detail < ActiveRecord::Base
  has_one :entity_detail, :foreign_key => :detail_id , :dependent => :destroy
  has_one :entity, :through=> :entity_detail

  belongs_to :entity
  validates_presence_of :entity
  validates_associated :entity
end
