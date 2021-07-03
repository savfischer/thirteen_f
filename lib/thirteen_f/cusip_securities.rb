# frozen_string_literal: true

require 'date'
require 'open-uri'
require 'pdf-reader'

class ThirteenF
  class CusipSecurities
    attr_reader :file_name, :file_location, :quarter, :period_end, :list_entries
    BASE_URL = 'https://www.sec.gov'

    def self.all_file_locations
      index_url = "#{BASE_URL}/divisions/investment/13flists.htm"
      page = SecRequest.get index_url, response_type: :html
      a_tags = page.search('a').select do |a_tag|
        href = a_tag.attributes['href']&.value.to_s
        href.include?('13flist') && href.include?('.pdf')
      end
      a_tags.map { |a_tag|"#{BASE_URL + a_tag.attributes['href'].value}" }
    end

    def self.most_recent_list
      index_url = "#{BASE_URL}/divisions/investment/13flists.htm"
      page = SecRequest.get index_url, response_type: :html
      a_tag = page.search('a').find { |a| a.text.include?('Current List') }
      file_location = "#{BASE_URL + a_tag.attributes['href'].value}"
      new file_location
    end

    def initialize(file_location)
      @file_location = file_location
      @file_name = file_location.split('/').last
      @quarter = set_quarter_string file_name
      @period_end = set_period_end file_name
      true
    end

    def get_list_entries
      return false unless file_location
      io = URI.open file_location
      reader = PDF::Reader.new io
      valid_entries = []
      reader.pages[2..-1].each do |page|
        lines = page.text.split("\n").reject(&:empty?)[3..-1]
        line_arrs = lines.map do |line|
          next nil if line.include?('Total Coun')
          line.split(/\s{3}|( \* )/).reject(&:empty?).map(&:strip).reject { |text| text == '*' }
        end
        line_arrs.compact.each do |line_arr|
          next unless line_arr.count > 1
          valid_entries.push ListEntry.new(line_arr)
        end
      end
      @list_entries = valid_entries
      true
    end

    class ListEntry
      attr_reader :cusip_number, :issuer_name, :issuer_description, :status

      def initialize(line_arr)
        @cusip_number = line_arr[0].delete(' ')
        @issuer_name = line_arr[1].delete('*').strip
        @issuer_description = line_arr[2]
        @status = line_arr[3] || 'N/A'
        true
      end
    end

    private
      def set_quarter_string(file_name)
        arr = file_name.sub('13flist', '').delete('.pdf').split('q')
        case arr[1].to_i
        when 1 then "1st Quarter #{arr[0]}"
        when 2 then "2nd Quarter #{arr[0]}"
        when 3 then "3rd Quarter #{arr[0]}"
        when 4 then "4th Quarter #{arr[0]}"
        end
      end

      def set_period_end(file_name)
        arr = file_name.sub('13flist', '').delete('.pdf').split('q')
        case arr[1].to_i
        when 1 then Date.parse("#{arr[0]}-03-31")
        when 2 then Date.parse("#{arr[0]}-06-30")
        when 3 then Date.parse("#{arr[0]}-09-30")
        when 4 then Date.parse("#{arr[0]}-12-31")
        end
      end
  end
end

