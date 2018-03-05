require 'json'
require 'colorize'
require 'smoke_tests/configuration/base'
require 'smoke_tests/storage/client'

module SmokeTests
  module Tariff
    # Responsible for collecting list of urls to visit
    class UrlCollector
      class << self
        def urls
          heading_endpoint = "#{SmokeTests::Configuration::Base.fe_environment_url}/trade-tariff/headings"
          commodity_endpoint = "#{SmokeTests::Configuration::Base.fe_environment_url}/trade-tariff/commodities"

          puts 'Using following endpoints: '.colorize(:green)
          puts "For Headings: #{heading_endpoint}".colorize(:green)
          puts "For Commodities: #{commodity_endpoint}".colorize(:green)

          list_of_urls = []
          headings = fetch_headings

          headings[:declarable].each do |goods_nomenclature_item_id|
            list_of_urls << "#{heading_endpoint}/#{goods_nomenclature_item_id}.json"
          end

          hydra = Typhoeus::Hydra.new(max_concurrency: SmokeTests::Configuration::Base.max_concurrency)

          headings[:non_declarable].each do |goods_nomenclature_item_id|
            url = "#{SmokeTests::Configuration::Base.be_environment_url}/headings/#{goods_nomenclature_item_id}/tree"
            puts "Fetching commodities from #{url}"
            request = ::Typhoeus::Request.new(url, followlocation: true)
            request.on_complete do |response|
              puts '-----------------------------------------------------------------------------------------------'.colorize(:blue)
              if response.success?
                fetch_commodities(response.body).each do |goods_nomenclature_item_id|
                  commodity_url = "#{commodity_endpoint}/#{goods_nomenclature_item_id}.json"
                  puts "Adding commodity #{commodity_url} to list of urls"
                  list_of_urls << commodity_url # maybe this becomes a memory bloat
                end
              elsif response.timed_out?
                SmokeTests::Storage::Client.save_failure(
                  'Collecting commodities from heading tree',
                  url,
                  'response timed out'
                )
                puts "got a time out".colorize(:red)
              elsif response.code == 0
                SmokeTests::Storage::Client.save_failure(
                  'Collecting commodities from heading tree',
                  url,
                  "Could not get an http response, something's wrong",
                  response.return_message
                )
                puts response.return_message.colorize(:red)
              else
                SmokeTests::Storage::Client.save_failure(
                  'Collecting commodities from heading tree',
                  url,
                  "HTTP request failed: #{response.code.to_s}"
                )
                # Received a non-successful http response. /headings/0511000000/tree
                puts "HTTP request failed: #{response.code.to_s}".colorize(:red)
              end
            end
            hydra.queue(request)
          end

          hydra.run

          list_of_urls
        end

        def fetch_commodities(response_body)
          response = JSON.parse(response_body)
          commodities = response['commodities']
          return [] if commodities.nil?
          commodities.map(&:values).flatten
        end

        def fetch_headings
          # will replace with real http call, it takes too long at this stage
          file = File.read('lib/section_tree.json')
          sections = JSON.parse(file)

          declarable_headings = []
          non_declarable_headings = []
          sections.each do |section|
            section['chapters'].each do |chapter|
              chapter['headings'].each do |heading|
                goods_nomenclature_item_id = heading['goods_nomenclature_item_id']
                if heading['declarable'] == true
                  declarable_headings << goods_nomenclature_item_id[0..3]
                else
                  non_declarable_headings << goods_nomenclature_item_id
                end
              end
            end
          end

          { declarable: declarable_headings, non_declarable: non_declarable_headings }
        end
      end
    end
  end
end
