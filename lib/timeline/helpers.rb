module Timeline
  module Helpers
    class DecodeException < StandardError; end

    def encode(object)
      ::MultiJson.dump(object)
    end

    def decode(object)
      return unless object

      begin
        ::MultiJson.load(object)
      rescue ::MultiJson::DecodeError => e
        raise DecodeException, e
      end
    end

    def get_list(options={})
      keys = Timeline.redis.lrange options[:list_name], options[:start], options[:end]
      return [] if keys.blank?
      Timeline.redis.mget(*keys)
    end
  end
end