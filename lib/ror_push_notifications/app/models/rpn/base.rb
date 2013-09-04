module Rpn

  RPN_TIME_TO_LIVE = 2419200 # 4 weeks

  class Base < ActiveRecord::Base

    def self.table_name_prefix
      'rpn_'
    end

    self.abstract_class = true
  end

end
