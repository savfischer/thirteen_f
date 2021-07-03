require 'test_helper'

class EntityTest < MiniTest::Test
  def setup
    @entity = ThirteenF::Entity.from_cik 'test'
  end

  def test_cik_string
    assert @entity.cik.is_a?(String)
  end

  def test_cik_has_length_10
    assert_equal @entity.cik.length, 10
  end

  def test_name_string
    assert @entity.name.is_a?(String)
  end

  def test_tickers_array
    assert @entity.tickers.is_a?(Array)
    assert @entity.tickers.all? { |ticker| ticker.is_a?(String) }
  end

  def test_exchanges_array
    assert @entity.exchanges.is_a?(Array)
    assert @entity.exchanges.all? { |exchange| exchange.is_a?(String) }
  end

  def test_sic_string
    assert @entity.sic.is_a?(String)
  end

  def test_sic_description_string
    assert @entity.sic_description.is_a?(String)
  end

  def test_fiscal_year_end_string
    assert @entity.fiscal_year_end.is_a?(String)
  end

  def test_human_fiscal_year_end_string
    fye = @entity.fiscal_year_end
    assert_equal fye, '1231'

    hfye = @entity.human_fiscal_year_end
    assert_equal hfye, 'December 31'
  end

  def test_business_state_or_country
    assert @entity.business_state_or_country.is_a?(String)
  end

  def test_filings
    assert @entity.filings.is_a?(Array)
    assert @entity.filings.all? { |filing| filing.is_a?(ThirteenF::Filing) }
  end

  def test_most_recent_positions
    @entity.get_most_recent_positions
    assert @entity.most_recent_positions.is_a?(Array)
    assert @entity.most_recent_positions.all? do |position|
      position.is_a?(ThirteenF::Position)
    end
  end
end

