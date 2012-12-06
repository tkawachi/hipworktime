require_relative 'time_range'
module HipWorkTime
  class Normalizer
    def initialize(work_times = nil)
      @work_times = work_times
    end

    attr_accessor :work_times

    def normalize
      return [] if @work_times.nil? || @work_times.size == 0

      worked_secs = @work_times.inject(0) { |a, e| a + e.seconds }
      start_datetime = @work_times[0].start_datetime.change(hour: 10)
      end_datetime = start_datetime + worked_secs.seconds

      # rest 1 hour for every 4 hours
      duration_sec = ((end_datetime - start_datetime) * 24 * 60 * 60).to_i
      rest_hours = duration_sec / (60 * 60 * 4)
      end_datetime += rest_hours.hours

      [TimeRange.new(start_datetime, end_datetime)]
    end
  end
end
