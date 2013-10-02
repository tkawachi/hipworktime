# coding: utf-8

require_relative 'time_range'
module HipWorkTime
  class Normalizer
    def initialize(work_times = nil)
      @work_times = work_times
    end

    attr_accessor :work_times

    def normalize
      return [] if @work_times.nil? || @work_times.size == 0

      end_datetime = start_datetime + worked_secs - missing_rest_secs + rest_secs

      [TimeRange.new(start_datetime, end_datetime)]
    end

    def worked_secs
      @work_times.inject(0) { |a, e| a + e.seconds }.seconds
    end

    def start_datetime
      @work_times[0].start_datetime.change(hour: 10)
    end

    # 入力忘れの休憩を推測して返す
    def missing_rest_secs
      x = rest_secs - interval_secs
      if x < 0
        0
      else
        x
      end
    end

    def interval_secs
      intervals = 0
      prev_work_time = nil
      @work_times.each do |work_time|
        if prev_work_time
          intervals += work_time.start_datetime - prev_work_time.end_datetime
        end
        prev_work_time = work_time
      end
      intervals * 24 * 60 * 60
    end

    def rest_secs
      # 常に2時間休憩したとする
      1.hours
    end
  end
end
