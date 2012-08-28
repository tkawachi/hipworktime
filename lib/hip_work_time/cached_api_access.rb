module HipWorkTime

  class CachedApiAccess
    class << self

      def api
        @api ||= HipChat::API.new(config[:api_key])
      end

      def get_config
        ENV['EDITOR'] = 'vi' unless ENV['EDITOR']
        Pit.get(
            'hipworktime',
            require: {
                api_key: 'HipChat admin API key to retrieve chat history. See https://www.hipchat.com/docs/api/auth',
                room_id: 'HipChat Room ID. Pick one from https://www.hipchat.com/rooms/ids',
                email: 'mail@example.com',
            }
        )
      end

      def config
        @config ||= get_config
      end

      def get_user_id
        api = HipChat::API.new(config[:api_key])
        resp = api.users_show(config[:email])
        resp.parsed_response['user']['user_id']
      end

      def user_id
        @user_id ||= get_user_id
      end

      # @param [Date] date
      # @return [Hash] Messages for given date
      def messages(date)
        @messages ||= {}
        if @messages.has_key? date
          @messages[date]
        else
          resp = api.rooms_history(config[:room_id], date.to_s, CONFIG[:timezone])
          if resp.code != 200
            raise RuntimeError.new("Getting history failed (code: #{resp.code}, #{resp.body})")
          end
          messages = resp.parsed_response['messages'].select do |message|
            message['from']['user_id'] == user_id
          end
          messages = messages.map { |hash| Message.new(hash) }
          @messages[date] = messages
          messages
        end
      end
    end
  end

end