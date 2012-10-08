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
      "#{'%02d' % @start_datetime.hour}:#{'%02d' % @start_datetime.minute} ~ " +
          "#{'%02d' % @end_datetime.hour}:#{'%02d' % @end_datetime.minute}"
    end
    attr_accessor :start_datetime, :end_datetime

    def seconds
      @end_datetime.new_offset.to_time - @start_datetime.new_offset.to_time
    end
  end
end
