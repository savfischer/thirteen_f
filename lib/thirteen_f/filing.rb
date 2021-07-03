# frozen_string_literal: true

require 'date'

class ThirteenF
  class Filing
    attr_reader :entity, :index_url, :report_date, :time_accepted, :form_type,
      :table_html_url, :table_xml_url,
      :cover_page_html_url, :cover_page_xml_url, :complete_text_file_url,
      :positions

    alias period_of_report report_date

    BASE_URL = 'https://www.sec.gov'

    def initialize(entity, columnar_data)
      @entity = entity
      @index_url = assemble_index_url columnar_data[0]
      @report_date = Date.parse columnar_data[2]
      @time_accepted = DateTime.parse columnar_data[3]
      @form_type = columnar_data[5]
      true
    end

    def assemble_index_url(accession_number)
      "#{BASE_URL}/Archives/edgar/data/#{entity.cik}/#{accession_number.delete('-')}/#{accession_number}-index.htm"
    end

    def get_positions
      set_attributes_from_index_url unless table_xml_url
      @positions = Position.from_xml_filing self
      true
    end

    def set_attributes_from_index_url
      return unless index_url
      response = SecRequest.get index_url, response_type: :html
      assign_attributes(**set_attributes(response))
    end

    private
      def set_attributes(page)
        table_links = page.search('table.tableFile')[0].search('a')
        attributes = Hash.new
        attributes[:complete_text_file_url] = "#{BASE_URL + table_links[-1].attributes['href'].value}"
        if table_links.count == 5
          attributes = xml_present(attributes, table_links)
        end
        attributes
      end

      def xml_present(attributes, table_links)
        attributes[:table_html_url] = "#{BASE_URL + table_links[2].attributes['href'].value}"
        attributes[:table_xml_url] = "#{BASE_URL + table_links[3].attributes['href'].value}"
        attributes[:cover_page_html_url] = "#{BASE_URL + table_links[0].attributes['href'].value}"
        attributes[:cover_page_xml_url] = "#{BASE_URL + table_links[1].attributes['href'].value}"
        attributes
      end

      def assign_attributes(complete_text_file_url:, table_html_url: nil,
                            table_xml_url: nil, cover_page_html_url: nil,
                            cover_page_xml_url: nil)
        @table_html_url = table_html_url
        @table_xml_url = table_xml_url
        @cover_page_html_url = cover_page_html_url
        @cover_page_xml_url = cover_page_xml_url
        @complete_text_file_url = complete_text_file_url
        true
      end
  end
end

