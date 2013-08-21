class Rpn::Device < Rpn::Base

  belongs_to :config, :polymorphic => true

  attr_accessible :guid
  attr_protected :config_id, :config_type

  validates :guid, :presence => true
  validates :config, :presence => true
end
