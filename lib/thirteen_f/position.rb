# frozen_string_literal: true

require 'http'

class ThirteenF
  class Position
    attr_reader :name_of_issuer, :title_of_class, :cusip, :value_in_thousands,
      :shares_or_principal_amount_type, :shares_or_principal_amount, :put_or_call,
      :investment_discretion, :other_managers, :voting_authority, :filing

    def self.from_xml_filing(filing)
      return unless filing.table_xml_url
      response = HTTP.get filing.table_xml_url
      xml_doc = Nokogiri::XML response.to_s
      xml_doc.search('infoTable').map do |info_table|
        position = new filing
        position.attributes_from_info_table(info_table)
        position
      end
    end

    def initialize(filing)
      @filing = filing
    end

    def attributes_from_info_table(info_table)
      @name_of_issuer = info_table.search('nameOfIssuer').text
      @title_of_class = info_table.search('titleOfClass').text
      @cusip = info_table.search('cusip').text
      @value_in_thousands = info_table.search('value').text
      @shares_or_principal_amount_type = info_table.search('sshPrnamtType').text
      @shares_or_principal_amount = info_table.search('sshPrnamt').text

      not_found = info_table.search('putCall').count == 0
      @put_or_call = info_table.search('putCall').text unless not_found

      @investment_discretion = info_table.search('investmentDiscretion').text
      @other_managers = info_table.search('otherManager').text
      @voting_authority = {
        sole: info_table.search('Sole').text,
        shared: info_table.search('Shared').text,
        none: info_table.search('None').text
      }
    end
  end
end

