require 'test_helper'

class SearchTest < Minitest::Test
  def test_search_params_is_array
    s = ThirteenF::Search.new 'Berkshire'
    assert s.search_params.is_a?(Array)
  end

  def test_search_url
    url = ThirteenF::Search::SEARCH_URL
    search_index_sec_url = 'https://efts.sec.gov/LATEST/search-index'
    assert_equal url, search_index_sec_url
  end

  def test_results
    s = ThirteenF::Search.new 'Berkshire'
    s.get_results
    assert s.results.is_a?(Array)
    assert s.results.first.is_a?(ThirteenF::SearchHit)
  end
end

