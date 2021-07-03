# frozen_string_literal: true

class ThirteenF
  class SearchHit
    attr_reader :cik, :name, :entity, :sec_page_url

    def self.from_search_hits(hits)
      hits.map { |hit| new hit }
    end

    BASE_URL = 'https://www.sec.gov'

    def initialize(sec_hit)
      @cik = cik_from_id sec_hit[:_id]
      @name = sec_hit[:_source][:entity]
      @sec_page_url = "#{BASE_URL}/edgar/browse/?CIK=#{cik}&owner=exclude"
      true
    end

    def get_entity
      entity_url = "https://data.sec.gov/submissions/CIK#{cik}.json"
      response = SecRequest.get entity_url
      @entity = Entity.new response
      true
    end

    private
      def cik_from_id(id)
        id.prepend('0') until id.length >= 10
        id
      end
  end
end

