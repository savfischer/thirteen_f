require 'test_helper'

class FilingTest < MiniTest::Test
  def setup
    entity = ThirteenF::Entity.from_cik 'test'
    @filing = entity.filings.first
  end

  def test_form_type_string_starts_with_13F
    assert @filing.form_type.start_with?('13F')
  end

  def test_positions_are_positions
    assert_nil @filing.positions
    @filing.set_attributes_from_index_url
    @filing.get_positions
    assert @filing.positions.is_a?(Array)
    assert @filing.positions.first.is_a?(ThirteenF::Position)
  end

  def test_pre_index_url
    assert_nil @filing.table_html_url
    assert_nil @filing.table_xml_url
    assert_nil @filing.cover_page_html_url
    assert_nil @filing.cover_page_xml_url
    assert_nil @filing.complete_text_file_url

    @filing.set_attributes_from_index_url

    assert @filing.table_html_url.is_a?(String)
    assert @filing.table_xml_url.is_a?(String)
    assert @filing.cover_page_html_url.is_a?(String)
    assert @filing.cover_page_xml_url.is_a?(String)
    assert @filing.complete_text_file_url.is_a?(String)
  end
end

