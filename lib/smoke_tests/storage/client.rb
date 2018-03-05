require 'redis'
require 'json'

module SmokeTests
  module Storage
    # Responsible for collecting list of urls to visit
    class Client
      KEY_NAMESPACE = 'smoke_tests'

      def self.reset
        keys = Redis.current.keys "#{KEY_NAMESPACE}*"
        Redis.current.del(*keys) unless keys.empty?
      end

      def self.save_success
        # To be implemented
      end

      def self.save_failure(phase, url, *details)
        Redis.current.set(
          "#{KEY_NAMESPACE}:#{url}",
          {
            url: url,
            phase: phase,
            details: details
          }.to_json
        )
      end
    end
  end
end
