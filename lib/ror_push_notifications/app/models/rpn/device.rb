class Rpn::Device < Rpn::Base

  belongs_to :config, :polymorphic => true

  attr_accessible :guid

  validates :guid, :presence => true
  validates :config, :presence => true
end
