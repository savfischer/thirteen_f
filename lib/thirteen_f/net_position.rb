# frozen_string_literal: true

class ThirteenF
  # a net position ignores the "other manager" and "investment discretion"
  # column and rollups positions by CUSIP, see a Berkshire Hathaway Inc 13-F for
  # why this is useful:
  # https://www.sec.gov/Archives/edgar/data/1067983/000095012320002466/xslForm13F_X01/form13fInfoTable.xml

  class NetPosition
    attr_reader :name_of_issuer, :title_of_class, :cusip, :value_in_thousands,
      :shares_or_principal_amount_type, :shares_or_principal_amount, :put_or_call,
      :investment_discretion, :voting_authority, :filing

    def self.call(positions)
      cusips = positions.map(&:cusip).uniq
      cusips.map do |cusip|
        subset = positions.select { |position| position.cusip == cusip }
        new(
          name_of_issuer: subset.first.name_of_issuer,
          cusip: cusip, title_of_class: subset.first.title_of_class,
          value_in_thousands: subset.map(&:value_in_thousands).sum,
          shares_or_principal_amount: subset.map(&:shares_or_principal_amount).sum,
          shares_or_principal_amount_type: subset.first.shares_or_principal_amount_type,
          put_or_call: subset.first.put_or_call,
          voting_authority: {
            sole: subset.map { |x| x.voting_authority[:sole] }.sum,
            shared: subset.map { |x| x.voting_authority[:shared] }.sum,
            none: subset.map { |x| x.voting_authority[:none] }.sum
          }
        )
      end
    end

    def initialize(cusip:, name_of_issuer:, title_of_class:, put_or_call:,
                   value_in_thousands:, shares_or_principal_amount:,
                   shares_or_principal_amount_type:, voting_authority:)
      @cusip = cusip
      @name_of_issuer = name_of_issuer
      @title_of_class = title_of_class
      @value_in_thousands = value_in_thousands
      @shares_or_principal_amount = shares_or_principal_amount
      @shares_or_principal_amount_type = shares_or_principal_amount_type
      @voting_authority = voting_authority
      true
    end

  end
end

