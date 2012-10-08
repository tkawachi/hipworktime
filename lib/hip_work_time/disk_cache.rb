require 'fileutils'
require 'digest'

module HipWorkTime
  class DiskCache
    def initialize(options = {})
      @save_dir = options[:save_dir] || ENV['HOME'] + "/.hipworktime/cache"
      FileUtils.mkdir_p(@save_dir)
      @digest_method = Digest::SHA256.new
    end

    # @param [String] key
    # @param [String] string
    def put(key, string)
      File.open(file_name(key), "w") do |out|
        out.write(string)
      end
    end

    def get(key)
      return nil unless has_key?(key)
      File.open(file_name(key)) do |input|
        return input.read
      end
    end

    def has_key?(key)
      File.exists?(file_name(key))
    end

    private
    def file_name(key)
      "#@save_dir/#{@digest_method.hexdigest(key)}"
    end
  end
end
