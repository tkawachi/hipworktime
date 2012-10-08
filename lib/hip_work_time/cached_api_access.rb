require 'json'
require_relative 'disk_cache'

module HipWorkTime

  class CachedApiAccess
    class << self

      def api(options = {})
        @api ||= begin
          api = HipChat::API.new(config[:api_key])
          api.set_timeout(options[:timeout] || 10)
          api
        end
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
          messages = get_json_message(date).select do |message|
            message['from']['user_id'] == user_id
          end
          @messages[date] = messages.map { |hash| Message.new(hash) }
        end
      end

      private
      def disk_cache
        @disk_cache ||= DiskCache.new
      end

      def get_json_message(date)
        cache_key = date.to_s
        if disk_cache.has_key?(cache_key)
          JSON.parse(disk_cache.get(cache_key))
        else
          resp = api.rooms_history(config[:room_id], date.to_s, CONFIG[:timezone])
          if resp.code != 200
            raise RuntimeError.new("Getting history failed (code: #{resp.code}, #{resp.body})")
          end
          messages = resp.parsed_response['messages']
          if date < Date.today - 2.days
            disk_cache.put(cache_key, messages.to_json)
          end
          messages
        end
      end
    end
  end

end
