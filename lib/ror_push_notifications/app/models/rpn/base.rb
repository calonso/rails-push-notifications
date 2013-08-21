module Rpn

  RPN_TIME_TO_LIVE = 4.weeks

  class Base < ActiveRecord::Base

    def self.table_name_prefix
      'rpn_'
    end

    self.abstract_class = true

    def self.table_name # :nodoc:
      self.to_s.gsub("::", "_").tableize
    end

  end

end
