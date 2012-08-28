module HipWorkTime
  class Message
    # @param [Hash] message_hash
    def initialize(message_hash)
      @datetime = DateTime.parse(message_hash['date'])
      @message = message_hash['message']
      @from = message_hash['from']
    end

    # @param [Date] date
    def for_date?(date)
      (@datetime - CONFIG[:date_break_hour].hours).to_date == date
    end

    def start?
      @message.strip == CONFIG[:start_keyword]
    end

    def end?
      @message.strip == CONFIG[:end_keyword]
    end

    def to_s
      "#{@datetime.to_s} <#{@from['name']}> #@message"
    end

    attr_reader :datetime, :message, :from
  end

end