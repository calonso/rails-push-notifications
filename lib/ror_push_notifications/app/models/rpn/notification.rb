module Rpn
  class Notification < ActiveRecord::Base

    belongs_to :config, polymorphic: true

    attr_accessible :sent_at

    validates :config, presence: true
    validates :data, presence: true

    self.abstract_class = true

    def self.table_name # :nodoc:
      self.to_s.gsub('::', '_').tableize
    end
  end
end
