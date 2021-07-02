require 'http'
require 'nokogiri'

class ThirteenF
  class SecRequest
    HEADERS = {
      'User-Agent' => 'ThirteenF/v0.5.0 (Open Source Ruby Gem)',
      'Accept-Encoding' => 'gzip, deflate',
      'Accept' => '*/*'
    }

    def self.get(url, html: false)
      response = HTTP.use(:auto_inflate).headers(HEADERS).get(url)
      handle_response response, html: html
    end

    def self.post(url, json)
      response = HTTP.use(:auto_inflate).headers(HEADERS).post(url, json: json)
      handle_response response
    end

    def self.handle_response(response, html: false)
      case response.status
      when 200, 201, 202, 203, 204, 206
        if html
          Nokogiri::HTML response.to_s
        else
          JSON.parse response.to_s, symbolize_names: true
        end
      else
        p response.to_s
        raise "Request failed with response #{response.status}, request url: #{response.uri.to_s}"
        false
      end
    end
  end
end

