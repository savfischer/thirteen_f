# frozen_string_literal: true

require 'http'
require 'date'

class ThirteenF
  class Filing
    attr_reader :index_url, :table_html_url, :table_xml_url,
      :cover_page_html_url, :cover_page_xml_url, :complete_text_file_url,
      :period_of_report, :time_accepted, :response_status

    BASE_URL = 'https://www.sec.gov'

    def self.from_index_urls(urls)
      redo_count = 0
      urls.map do |index_url|
        response = HTTP.get index_url
        sleep 0.33
        if response.status == 200
          redo_count = 0
          attributes = set_attributes(response, index_url)
          new(**attributes)
        else
          redo_count += 1
          redo unless redo_count > 1
          attributes = bad_response_attributes(response, index_url)
          new(**attributes)
        end
      end
    end

    def reset_attributes_from_index_url
      return unless index_url
      response = HTTP.get index_url
      sleep 0.33
      if response.status == 200
        attributes = self.class.set_attributes(response, index_url)
        assign_attributes(**attributes)
        true
      else
        false
      end
    end

    def initialize(response_status:, index_url:, complete_text_file_url:,
                   period_of_report:, time_accepted:, table_html_url: nil,
                   table_xml_url: nil, cover_page_html_url: nil,
                   cover_page_xml_url: nil)
      @response_status = response_status
      @index_url = index_url
      @table_html_url = table_html_url
      @table_xml_url = table_xml_url
      @cover_page_html_url = cover_page_html_url
      @cover_page_xml_url = cover_page_xml_url
      @complete_text_file_url = complete_text_file_url
      @period_of_report = period_of_report
      @time_accepted = time_accepted
      true
    end

    private
      def self.set_attributes(response, index_url)
        page = Nokogiri::HTML response.to_s
        table_links = page.search('table.tableFile')[0].search('a')
        attributes = Hash.new
        attributes[:response_status] = response.status.to_s
        attributes[:index_url] = index_url
        attributes[:period_of_report] = get_period_of_report page
        attributes[:time_accepted] = get_time_accepted page
        attributes[:complete_text_file_url] = "#{BASE_URL + table_links[-1].attributes['href'].value}"
        if table_links.count == 5
          attributes = xml_present(attributes, table_links)
        end
        attributes
      end

      def self.get_period_of_report(page)
        period_header_div = page.search('div.infoHead').find do |div|
          div.text.include?('Period of Report')
        end
        period_string = period_header_div.next.next.text.strip
        Date.parse period_string
      end

      def self.get_time_accepted(page)
        accepted_header_div = page.search('div.infoHead').find do |div|
          div.text.include?('Accepted')
        end
        accepted_string = accepted_header_div.next.next.text.strip
        DateTime.parse accepted_string
      end

      def self.xml_present(attributes, table_links)
        attributes[:table_html_url] = "#{BASE_URL + table_links[2].attributes['href'].value}"
        attributes[:table_xml_url] = "#{BASE_URL + table_links[3].attributes['href'].value}"
        attributes[:cover_page_html_url] = "#{BASE_URL + table_links[0].attributes['href'].value}"
        attributes[:cover_page_xml_url] = "#{BASE_URL + table_links[1].attributes['href'].value}"
        attributes
      end

      def self.bad_response_attributes(response, index_url)
        attributes = Hash.new
        attributes[:response_status] = response.status.to_s
        attributes[:index_url] = index_url
        attributes[:period_of_report] = nil
        attributes[:time_accepted] = nil
        attributes[:complete_text_file_url] = nil
        attributes
      end

      def assign_attributes(response_status:, index_url:, complete_text_file_url:,
                    period_of_report:, time_accepted:, table_html_url: nil,
                    table_xml_url: nil, cover_page_html_url: nil,
                    cover_page_xml_url: nil)
        @response_status = response_status
        @index_url = index_url
        @table_html_url = table_html_url
        @table_xml_url = table_xml_url
        @cover_page_html_url = cover_page_html_url
        @cover_page_xml_url = cover_page_xml_url
        @complete_text_file_url = complete_text_file_url
        @period_of_report = period_of_report
        @time_accepted = time_accepted
        true
      end
  end
end

