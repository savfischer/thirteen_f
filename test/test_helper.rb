$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "thirteen_f"
require "minitest/autorun"

##
# Mock HTTP requests to the SEC
#
class ThirteenF
  class SecRequest
    def self.get(url, response_type: :json)
      response = return_fixture url
      handle_response response, response_type: response_type
    end

    def self.post(url, json)
      response = return_fixture url
      handle_response response
    end

    private
      def self.return_fixture(url)
        case url
        when /data.sec.gov/
          read_fixture 'entity', url
        when /search-index/
          read_fixture 'search_index', url
        when /index.htm\z/
          read_fixture 'filing_index_page', url
        when /xml\z/
          read_fixture 'xml_table', url
        end
      end

      def self.read_fixture(filename, uri)
        filepath = File.join("test", "fixtures", filename)
        s = File.read(filepath).strip.gsub(/\n\s*/, '')
        MockHttpResponse.new(body: s, status: 200, uri: uri)
      end
  end
end

class MockHttpResponse
  attr_reader :status, :body, :uri

  def initialize(options = {})
    @status = options[:status]
    @body = options[:body]
    @headers = options[:headers] || {}
    @uri = options[:uri]
  end

  def to_s
    body.to_s
  end

  def [](key)
    @headers[key]
  end
end

