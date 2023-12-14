require 'test_helper'

class PositionTest < Minitest::Test
  def setup
    entity = ThirteenF::Entity.from_cik 'test'
    entity.get_most_recent_positions
    @position = entity.most_recent_positions.first
  end

  def test_name_of_issuer_string
    assert @position.name_of_issuer.is_a?(String)
  end

  def test_title_of_class_string
    assert @position.title_of_class.is_a?(String)
  end

  def test_cusip_string
    assert @position.cusip.is_a?(String)
  end

  def test_value_in_thousands_integer
    assert @position.value_in_thousands.is_a?(Float)
  end

  def test_shares_or_principal_amount_type_string
    assert @position.shares_or_principal_amount_type.is_a?(String)
  end

  def test_shares_or_principal_amount_integer
    assert @position.shares_or_principal_amount.is_a?(Float)
  end

  # this is the default case, since for most investors puts and calls are going
  # to be seen less frequently than equity shares directly
  def test_put_or_call_string
    assert_nil @position.put_or_call
  end

  def test_investment_discretion_string
    assert @position.investment_discretion.is_a?(String)
  end

  def test_other_managers_string
    assert @position.other_managers.is_a?(String)
  end

  def test_voting_authority_hash
    assert @position.voting_authority.is_a?(Hash)
    assert @position.voting_authority[:sole].is_a?(Float)
    assert @position.voting_authority[:shared].is_a?(Float)
    assert @position.voting_authority[:none].is_a?(Float)
  end

  def test_filing_is_filing
    assert @position.filing.is_a?(ThirteenF::Filing)
  end
end

