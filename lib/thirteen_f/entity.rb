# frozen_string_literal: true

require 'thirteen_f/sec_request'

class ThirteenF
  class Entity
    attr_reader :cik, :name, :tickers, :exchanges,
      :sic, :sic_description,
      :fiscal_year_end,
      :business_state_or_country,
      :filings, :most_recent_holdings

    BASE_URL = 'https://www.sec.gov'

    def self.from_cik(cik)
      entity_url = "https://data.sec.gov/submissions/CIK#{cik}.json"
      new SecRequest.get entity_url
    end

    def initialize(sec_entity)
      @name = sec_entity[:name]
      @cik = cik_from_id sec_entity[:cik]
      @tickers = sec_entity[:tickers]
      @exchanges = sec_entity[:exchanges]
      @sic = sec_entity[:sic]
      @sic_description = sec_entity[:sicDescription]
      @fiscal_year_end = sec_entity[:fiscalYearEnd]
      @business_state_or_country = sec_entity[:addresses][:business][:stateOrCountry]
      @filings = thirteen_f_filing_data sec_entity[:filings][:recent]
      true
    end


    def human_fiscal_year_end
      Time.strptime(@fiscal_year_end, '%m%d').strftime('%B %d')
    end

    def get_most_recent_holdings
      get_filings unless filings
      most_recent_filing.get_positions
      @most_recent_holdings =  most_recent_filing.positions
      true
    end

    def most_recent_filing
      filings.select(&:period_of_report).max_by(&:period_of_report)
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

    def thirteen_f_urls(count: 10)
      response = HTTP.get thirteen_f_filings_url(count: count)
      page = Nokogiri::HTML response.to_s
      page.search('#documentsbutton').map do |btn|
        next nil unless btn.parent.previous.previous.text.include?('13F-HR')
        "#{BASE_URL + btn.attributes['href'].value}"
      end.compact
    end

    private
      def cik_from_id(id)
        id.prepend('0') until id.length >= 10
        id
      end

      def thirteen_f_filing_data(filings_data)
        indexes = thirteen_f_indexes(filings_data)
        indexes.map do |index|
          columnar_data = [
            filings_data[:accessionNumber][index],
            filings_data[:filingDate][index],
            filings_data[:reportDate][index],
            filings_data[:acceptanceDateTime][index],
            filings_data[:act][index],
            filings_data[:form][index],
            filings_data[:fileNumber][index],
            filings_data[:filmNumber][index],
            filings_data[:items][index],
            filings_data[:size][index],
            filings_data[:isXBRL][index],
            filings_data[:isInlineXBRL][index],
            filings_data[:primaryDocument][index],
            filings_data[:primaryDocDescription][index]
          ]
          Filing.new self, columnar_data
        end
      end

      def thirteen_f_indexes(filings_data)
        filings_data[:form].each_with_index.map do |form, i|
          form.start_with?('13F') ? i : nil
        end.compact
      end
  end
end

