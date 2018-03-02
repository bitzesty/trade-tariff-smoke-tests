require 'smoke_tests/tariff/url_collector'
require 'singleton'

module SmokeTests
  module Configuration
    # Defines the available configuration options for the configuration
    ConfigurationStruct = Struct.new(:max_concurrency, :list_of_urls, :verbose, :environment)
    ENVIRONMENTS = {
      local: 'http://localhost:3000',
      dev: 'https://dev.trade-tariff.service.gov.uk',
      staging: 'https://staging.trade-tariff.service.gov.uk',
      production: 'https://www.trade-tariff.service.gov.uk'
    }

    class Base
      include ::Singleton

      # Initialize the configuration and set defaults:
      @@config = ConfigurationStruct.new

      # This is where the defaults are being set
      @@config.environment = :local
      @@config.max_concurrency = 20
      @@config.list_of_urls = []
      @@config.verbose = false

      def self.config
        yield(@@config) if block_given?
        @@config
      end

      def self.environment_url
        SmokeTests::Configuration::ENVIRONMENTS[@@config.environment]
      end

      # This provides an easy way to dump the configuration as a hash
      def self.to_hash
        Hash[@@config.each_pair.to_a]
      end

      # Pass any other calls (most likely attribute setters/getters on to the
      # configuration as a way to easily set/get attribute values
      def self.method_missing(method, *args, &block)
        if @@config.respond_to?(method)
          @@config.send(method, *args, &block)
        else
          raise NoMethodError
        end
      end

      # Handles validating the configuration that has been loaded/configured
      def self.validate!
        valid = true

        valid = false if Configuration.required.nil?

        raise ArgumentError unless valid
      end
    end
  end
end
