# frozen_string_literal: true

require 'http'

class ThirteenF
  class Company
    attr_reader :cik, :name, :state_or_country

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

    def initialize(cik, name, state_or_country)
      @cik = cik
      @name = name
      @state_or_country = state_or_country
      true
    end

    def sec_filings_page_url
      "#{BASE_URL}/cgi-bin/browse-edgar?CIK=#{cik}"
    end

    def thirteen_f_filings_url(count: 100)
      "#{sec_filings_page_url}&type=13f&count=#{count}"
    end

    def get_links_to_filings
      response = HTTP.get thirteen_f_filings_url
      page = Nokogiri::HTML response.to_s
      # compare these two - documents_button would be more direct
      rows = page.search('table/tableFile2 > tr')[1..-1]
      btns = page.search('#documentsbutton')
      p [rows.count, btns.count]
    end

    private
      def self.parse_name(name_cell)
        name_cell.text.split("\n").first
      end
  end
end

