require 'test_helper'

class SearchHitTest < MiniTest::Test
  def setup
    s = ThirteenF::Search.new 'Berkshire'
    s.get_results
    @search_hit = s.results.first
  end

  def test_cik_has_length_10
    assert @search_hit.cik.length == 10
  end

  def test_name
    assert @search_hit.name == 'BERKSHIRE HATHAWAY INC (BRK-B, BRK-A)'
  end

  def test_entity
    @search_hit.get_entity
    entity = @search_hit.entity
    assert entity.is_a?(ThirteenF::Entity)
  end

  def test_sec_page_url
    url = 'https://www.sec.gov/edgar/browse/?CIK=0001067983&owner=exclude'
    assert_equal @search_hit.sec_page_url, url
  end
end

