require_relative 'normalizer'

module HipWorkTime
  class WorkTime
    def initialize(target_date)
      @target_date = target_date
      @messages = []
    end

    # @param [Message] message
    def add_message(message)
      # Filter by @target_date
      if message.for_date? @target_date
        @messages << message
      end
    end

    def add_messages(messages)
      messages.each { |message| add_message message }
    end

    def work_times
      is_working = false
      result = []
      time_range = nil
      last_message = nil
      messages = @messages.sort { |a, b| a.datetime <=> b.datetime }
      messages.each do |message|
        if is_working
          if message.end?
            time_range.end_datetime = message.datetime
            result << time_range
            time_range = nil
            is_working = false
          elsif message.start?
            # 二度スタートした。
            # 直前の message からこのメッセージまでが 1h よりながければこれを休憩時間とみなす
            if last_message && (message.datetime.to_time - last_message.datetime.to_time > 1.hour)
              time_range.end_datetime = last_message.datetime
              result << time_range
              time_range = TimeRange.new(message.datetime)
            end
          end
        else
          if message.start?
            time_range = TimeRange.new(message.datetime)
            is_working = true
          elsif message.end?
            # start なしで end が着た。
            # result の最後の end_datetime もしくは日の始まりから数えて、最初の message を start とみなす。
            # そのようなメッセージがなければ無視する。
            if result.size > 0
              from_dt = result.last.end_datetime
            else
              from_dt = @target_date + CONFIG[:date_break_hour].hours
            end
            first_message = messages.select { |m| m.datetime > from_dt }.first
            if first_message
              result << TimeRange.new(first_message.datetime, message.datetime)
            end
          end
        end

        last_message = message
      end

      if is_working
        # 最後に end し忘れた。
        # 最後の message を end とみなす。
        if messages.last.datetime > time_range.start_datetime
          time_range.end_datetime = messages.last.datetime
          result << time_range
          time_range = nil
          is_working = false
        end
      end

      result
    end

    def normalized_work_times
      Normalizer.new(work_times).normalize
    end

    def to_s
      "#@target_date " +
          "#{normalized_work_times.map { |time_range| time_range.to_short_s }}" +
          " #{work_times.map { |time_range| time_range.to_short_s }}"
    end

    attr_accessor :start_datetime, :end_datetime, :break_hours
  end
end
