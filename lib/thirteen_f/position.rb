# frozen_string_literal: true

class ThirteenF
  class Position
    attr_reader :name_of_issuer, :title_of_class, :cusip, :value_in_thousands,
      :shares_or_principal_amount_type, :shares_or_principal_amount, :put_or_call,
      :investment_discretion, :other_managers, :voting_authority, :filing

    def self.from_xml_filing(filing)
      return nil unless filing.table_xml_url
      from_xml_url(filing.table_xml_url, filing: filing)
    end

    def self.from_xml_url(table_xml_url, filing: nil)
      xml_doc = SecRequest.get table_xml_url, response_type: :xml
      xml_doc.search("//infoTable").map do |info_table|
        position = new filing: filing
        position.attributes_from_info_table(info_table)
        position
      end
    end

    def initialize(filing: nil)
      @filing = filing
    end

    def attributes_from_info_table(info_table)
      @name_of_issuer = info_table.search('nameOfIssuer').text
      @title_of_class = info_table.search('titleOfClass').text
      @cusip = info_table.search('cusip').text
      @value_in_thousands = set_value_to_thousands info_table.search('value').text
      @shares_or_principal_amount_type = info_table.search('sshPrnamtType').text
      @shares_or_principal_amount = to_integer(info_table.search('sshPrnamt').text)

      not_found = info_table.search('putCall').count == 0
      @put_or_call = info_table.search('putCall').text unless not_found

      @investment_discretion = info_table.search('investmentDiscretion').text
      @other_managers = info_table.search('otherManager').text
      @voting_authority = {
        sole: to_integer(info_table.search('Sole').text),
        shared: to_integer(info_table.search('Shared').text),
        none: to_integer(info_table.search('None').text)
      }
    end

    private
      # https://www.sec.gov/divisions/investment/13ffaq#62
      # Q: When must filers use the updated Form 13F that includes the
      # amendments that were adopted on June 23, 2022?
      # A: The compliance date for the form amendments to Form 13F is January 3,
      # 2023.  All Form 13F reports that are filed on or after January 3, 2023,
      # whether public or confidential (including all Form 13F reports for the
      # quarter ending December 31, 2022, and for any other preceding or
      # succeeding calendar quarter), must use the updated Form 13F.
      def set_value_to_thousands(text)
        before_change = filing.time_accepted < Date.parse('2023-01-03')
        if before_change
          to_integer(text)
        else
          to_integer(text) / 1000
        end
      end

      def to_integer(text)
        text.delete(',').to_f
      end
  end
end

