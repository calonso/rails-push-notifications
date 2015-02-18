class Rpn::Device < Rpn::Base

  belongs_to :config, polymorphic: true

  validates :guid, :presence => true
  validates :config, :presence => true

end
