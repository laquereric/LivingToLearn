class EntityDetail < ActiveRecord::Base

  belongs_to :entity
  belongs_to :detail, :polymorphic => true

  named_scope :with_entity_id, lambda { |eid| {:conditions => ["entity_id = ?", eid ] } }
  named_scope :with_detail_type, lambda { |dt| {:conditions => ["detail_type = ?", dt ] } }
  named_scope :with_detail_id, lambda { |did| {:conditions => ["detail_id = ?", did ] } }

  validates_presence_of :entity
  validates_associated :entity

  validates_presence_of :detail
  validates_associated :detail

end
