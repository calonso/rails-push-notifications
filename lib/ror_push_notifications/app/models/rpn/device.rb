class Rpn::Device < Rpn::Base

  belongs_to :config, polymorphic: true
  has_many :notifications, polymorphic: true, dependent: :delete_all, as: :device

  attr_accessible :guid

  validates :guid, :presence => true
  validates :config, :presence => true
end
