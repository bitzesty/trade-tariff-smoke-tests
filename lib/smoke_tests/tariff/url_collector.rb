require 'json'

module SmokeTests
  module Tariff
    # Responsible for collecting list of urls to visit
    class UrlCollector
      def self.urls
        list_of_urls = []
        base_url = 'http://localhost:3000/trade-tariff/headings'
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

        declarable_headings.each do |goods_nomenclature_item_id|
          list_of_urls << "#{base_url}/#{goods_nomenclature_item_id}.json"
        end

        list_of_urls
      end
    end
  end
end
