module Rpn
  class Notification < ActiveRecord::Base

    attr_protected :config_id, :data
    attr_accessible :sent_at

    validates :config, :presence => true
    validates :data, :presence => true

    self.abstract_class = true

    def self.table_name # :nodoc:
      self.to_s.gsub('::', '_').tableize
    end

    def self.int_to_4_bytes_array value
      [value & 0xFF000000, value & 0xFF0000, value & 0xFF00, value & 0xFF]
    end

    def self.int_to_2_bytes_array value
      [value & 0xFF00, value & 0xFF]
    end
  end
end
