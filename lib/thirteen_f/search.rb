# frozen_string_literal: true

require 'thirteen_f/sec_request'

class ThirteenF
  class Search
    attr_reader :results, :search_params

    SEARCH_URL = 'https://efts.sec.gov/LATEST/search-index'

    def initialize(search_string, count: 100)
      @search_params = [SEARCH_URL, { keysTyped: search_string, narrow: true }]
    end

    def get_results
      response = SecRequest.post *search_params
      @results = configure_search_results response
      true
    end

    private
      def configure_search_results(response)
        if response.dig(:hits, :hits)
          SearchHit.from_search_hits response.dig(:hits, :hits)
        else []
        end
      end
  end
end

