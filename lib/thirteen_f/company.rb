# frozen_string_literal: true

require 'http'

class ThirteenF
  class Company
    attr_reader :cik, :name, :state_or_country, :filings, :most_recent_holdings

    BASE_URL = 'https://www.sec.gov'

    def self.from_sec_search_rows(rows)
      rows.map do |row|
        raise "Bad row" unless row.search('td').count == 3
        cells = row.search('td')
        cik = cells.first.text
        name = parse_name cells[1]
        state_or_country = cells.last.text
        new cik, name, state_or_country
      end
    end

    def self.from_company_page(page)
      arr = page.search('.companyName').text.split('CIK#:')
      name = arr.first.strip
      cik = arr.last.strip.split(' ').first
      state_or_country = page.search('.identInfo a').first.text
      Array.new 1, new(cik, name, state_or_country)
    end

    def self.from_cik(cik)
      response = HTTP.get sec_url_from_cik(cik)
      return false unless response.status == 200
      page = Nokogiri::HTML response.to_s
      from_company_page page
    end

    def initialize(cik, name, state_or_country)
      @cik = cik
      @name = name
      @state_or_country = state_or_country
      true
    end

    def get_most_recent_holdings
      get_filings unless filings
      most_recent_filing = filings.select(&:period_of_report).max_by(&:period_of_report)
      most_recent_filing.get_positions
      @most_recent_holdings =  most_recent_filing.positions
      true
    end

    def get_filings(count: 10)
      @filings = Filing.from_index_urls thirteen_f_urls(count: count), self
      true
    end

    def sec_filings_page_url
      "#{BASE_URL}/cgi-bin/browse-edgar?CIK=#{cik}"
    end

    def thirteen_f_filings_url(count: 10)
      "#{sec_filings_page_url}&type=13f&count=#{count}"
    end

    def self.sec_url_from_cik(cik)
      "#{BASE_URL}/cgi-bin/browse-edgar?CIK=#{cik}"
    end

    private
      def self.parse_name(name_cell)
        name_cell.text.split("\n").first
      end

      def thirteen_f_urls(count: 100)
        response = HTTP.get thirteen_f_filings_url(count: count)
        page = Nokogiri::HTML response.to_s
        page.search('#documentsbutton').map do |btn|
          "#{BASE_URL + btn.attributes['href'].value}"
        end
      end
  end
end

