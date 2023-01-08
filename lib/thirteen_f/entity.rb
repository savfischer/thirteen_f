# frozen_string_literal: true

require 'thirteen_f/sec_request'

class ThirteenF
  class Entity
    attr_reader :cik, :name, :tickers, :exchanges,
      :sic, :sic_description,
      :fiscal_year_end,
      :business_state_or_country,
      :filings, :most_recent_positions

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

    def get_most_recent_positions
      most_recent_filing.get_positions
      @most_recent_positions =  most_recent_filing.positions
      true
    end

    def most_recent_filing
      filings.select(&:period_of_report).max_by(&:period_of_report)
    end

    private
      def cik_from_id(id)
        id.to_i.to_s
      end

      COLUMN_KEYS = %i(
        accessionNumber
        filingDate
        reportDate
        acceptanceDateTime
        act
        form
        fileNumber
        filmNumber
        items
        size
        isXBRL
        isInlineXBRL
        primaryDocument
        primaryDocDescription
      )

      def thirteen_f_filing_data(filings_data)
        indexes = thirteen_f_indexes(filings_data)
        indexes.map do |index|
          columnar_data = COLUMN_KEYS.map do |key|
            filings_data[key][index]
          end
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

