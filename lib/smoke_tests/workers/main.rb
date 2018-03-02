require 'typhoeus'
require 'smoke_tests/configuration/base'
require 'smoke_tests/tariff/url_collector'
require 'benchmark'

module SmokeTests
  module Workers
    class Main
      def self.start
        puts 'Using following configuration'
        puts SmokeTests::Tariff::UrlCollector.urls
        exit

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
                puts 'Hellze year'
              elsif response.timed_out?
                # aw hell no
                puts("got a time out")
              elsif response.code == 0
                # Could not get an http response, something's wrong.
                puts(response.return_message)
              else
                # Received a non-successful http response.
                puts("HTTP request failed: " + response.code.to_s)
              end
            end
            hydra.queue(request)
          end
          hydra.run
        end
        puts time.real
      end
    end
  end
end
