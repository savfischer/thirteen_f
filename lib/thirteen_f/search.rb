# frozen_string_literal: true

require 'http'
require 'nokogiri'
require 'pry'

class ThirteenF
  class Search
    attr_reader :companies, :search_params

    BASE_URL = 'https://www.sec.gov'
    SEARCH_URL = "#{BASE_URL}/cgi-bin/browse-edgar"

    def initialize(search_string, count: 100)
      @search_params = [SEARCH_URL, params: {
        company: search_string,
        count: count
      }]
    end

    def get_companies
      response = HTTP.get(*search_params)
      if response.status == 200
        @companies = configure_search_results response
      else
        raise 'SEC results are not available right now'
      end

    end

    private
      def configure_search_results(response)
        page = Nokogiri::HTML response.to_s
        company_rows = page.search('table.tableFile2 > tr')[1..-1]
        column_count = company_rows.first.search('td').count
        if column_count == 3
          company_rows.search('br').each { |n| n.replace("\n") }
          Company.from_sec_search_rows company_rows
        elsif column_count == 5
          Company.from_company_page page
        end
      end
  end
end

