require 'smoke_tests/tariff/url_collector'
require 'singleton'

module SmokeTests
  module Configuration
    # Defines the available configuration options for the configuration
    ConfigurationStruct = Struct.new(:max_concurrency, :list_of_urls, :verbose, :environment)
    ENVIRONMENTS = {
      local: {
        'front-end' => 'http://localhost:3000',
        'back-end' => 'http://localhost:3018'
      },
      dev: {
        'front-end' => 'https://dev.trade-tariff.service.gov.uk',
        'back-end' => 'https://tariff-backend-dev.cloudapps.digital'
      },
      staging: {
        'front-end' => 'https://staging.trade-tariff.service.gov.uk',
        'back-end' => ''
      },
      production: {
        'front-end' => 'https://www.trade-tariff.service.gov.uk',
        'back-end' => ''
      }
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

      def self.be_environment_url
        SmokeTests::Configuration::ENVIRONMENTS.dig(@@config.environment, 'back-end')
      end

      def self.fe_environment_url
        SmokeTests::Configuration::ENVIRONMENTS.dig(@@config.environment, 'front-end')
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
