module HipWorkTime
  class TimeRange
    def initialize(start_datetime = nil, end_datetime = nil)
      @start_datetime = start_datetime
      @end_datetime = end_datetime
    end

    def to_s
      "#@start_datetime ~ #@end_datetime"
    end

    def to_short_s
      "#{@start_datetime.hour}:#{@start_datetime.minute} ~ #{@end_datetime.hour}:#{@end_datetime.minute}"
    end
    attr_accessor :start_datetime, :end_datetime
  end
end