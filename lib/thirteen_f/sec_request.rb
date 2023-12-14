require 'http'
require 'nokogiri'

class ThirteenF
  class SecRequest
    def self.data_headers
      {
        'User-Agent' => "ThirteenF/v#{::ThirteenF::VERSION} (Open Source Ruby Gem) savannah.fischer@hey.com",
        'Host' => 'data.sec.gov',
        'Accept-Encoding' => 'gzip, deflate'
      }
    end

    def self.www_headers
      {
        'User-Agent' => "ThirteenF/v#{::ThirteenF::VERSION} (Open Source Ruby Gem) savannah.fischer@hey.com",
        'Host' => 'www.sec.gov'
      }
    end

    EFTS_HEADERS = {
      'User-Agent' => 'S Fischer sfischer@fischercompany.com',
      'Accept-Encoding' => 'gzip, deflate',
      'Host' => 'efts.sec.gov'
    }

    def self.get(url, response_type: :json)
      case response_type
      when :json
        response = HTTP.use(:auto_inflate).headers(data_headers).get(url)
        handle_response response, response_type: response_type
      else
        response = HTTP.use(:auto_inflate).headers(www_headers).get(url)
        handle_response response, response_type: response_type
      end
    rescue
      raise "Request failed at this url: #{url} \n With this response #{response.to_s}"
    end

    def self.post(url, json)
      response = HTTP.use(:auto_inflate).headers(EFTS_HEADERS).post(url, json: json)
      handle_response response
    end

    def self.handle_response(response, response_type: :json)
      case response.status
      when 200, 201, 202, 203, 204, 206
        handle_response_type response.to_s, response_type
      else
        raise "Request failed with response #{response.status}, request url: #{response.uri.to_s}"
      end
    end

    def self.handle_response_type(body, response_type)
      case response_type
      when :html
        Nokogiri::HTML body
      when :json
        JSON.parse body, symbolize_names: true
      when :xml
        xml_doc = Nokogiri::XML body
        xml_doc.remove_namespaces!
      end
    end
  end
end

