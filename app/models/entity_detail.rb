class EntityDetail < ActiveRecord::Base

  belongs_to :entity
  belongs_to :detail, :polymorphic => true

  validates_presence_of :entity
  validates_associated :entity

  validates_presence_of :detail
  validates_associated :detail

end
