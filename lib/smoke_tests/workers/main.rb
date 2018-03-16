require 'typhoeus'
require 'smoke_tests/configuration/base'
require 'smoke_tests/tariff/url_collector'
require 'smoke_tests/storage/client'
require 'benchmark'

module SmokeTests
  module Workers
    class Main
      def self.start
        puts 'Using following configuration'.colorize(:green)
        puts 'Reseting storage'
        SmokeTests::Storage::Client.reset
        puts 'Done reseting storage'
        puts SmokeTests::Configuration::Base.to_hash
        SmokeTests::Tariff::UrlCollector.urls

        ::Typhoeus::Config.memoize = false
        hydra = Typhoeus::Hydra.new(max_concurrency: SmokeTests::Configuration::Base.max_concurrency)
        list_of_urls = SmokeTests::Tariff::UrlCollector.urls
        puts "Starting up! Going over #{list_of_urls.size} URLs"
        time = Benchmark.measure do
          list_of_urls.each do |url|
            puts "Starting with URL #{url}"
            request = ::Typhoeus::Request.new(url, followlocation: true)
            request.on_complete do |response|
              if response.success?
              elsif response.timed_out?
                SmokeTests::Storage::Client.save_failure(
                  'Visiting commodity',
                  url,
                  'response timed out'
                )
                puts "got a time out".colorize(:red)
              elsif response.code == 0
                SmokeTests::Storage::Client.save_failure(
                  'Visiting commodity',
                  url,
                  "Could not get an http response, something's wrong.",
                  response.return_message
                )
                puts response.return_message.colorize(:red)
              else
                SmokeTests::Storage::Client.save_failure(
                  'Visiting commodity',
                  url,
                  "HTTP request failed: #{response.code.to_s}"
                )
                puts "HTTP request failed: #{response.code.to_s}".colorize(:red)
              end
            end
            hydra.queue(request)
          end
          hydra.run
        end
        puts "DONE SMOKE TESTING IT TOOK #{time.real}".green
      end
    end
  end
end
