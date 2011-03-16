# Include hook code here
require 'active_record_numeric_extend'

ActiveRecord::Base.class_eval do
    include ActiveRecord::NumericExtend
end
