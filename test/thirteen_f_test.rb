require "test_helper"

class ThirteenFTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::ThirteenF::VERSION
  end

  def test_initializing_classes
    search = ThirteenF::Search.new('BAUPOST GROUP LLC/MA')
    search.get_companies
  end
end
