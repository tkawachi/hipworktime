module HipWorkTime
  class TimeRange
    def initialize(start_datetime = nil, end_datetime = nil)
      @start_datetime = start_datetime
      @end_datetime = end_datetime
    end

    def to_s
      "#{@start_datetime} ~ #{@end_datetime}"
    end
    attr_accessor :start_datetime, :end_datetime
  end
end