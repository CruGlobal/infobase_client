require 'rest-client'
require 'oj'
require 'retryable'

module Infobase
  class Base

    def initialize(hash)
      @item = hash
    end

    def [](key)
      @item[key.to_s]
    end

    def keys
      @item.keys
    end

    def to_s
      @item['to_s'] || super
    end

    def method_missing(symbol, &block)
      key = symbol.to_s

      return @item[key] if @item.keys.include?(key)

      super
    end

    def respond_to?(symbol, include_private = false)
      @item.keys.include?(symbol.to_s) || super
    end

    def self.find(id, params = {})
      request(:get, params, path_with_id(id))
    end

    def self.singular_name
      to_s.split('::').last.underscore
    end

    def self.plural_name
      singular_name.pluralize
    end

    def self.get(params = {})
      request(:get, params)
    end

    def self.post(params = {})
      request(:post, params)
    end

    def self.put(id, params = {})
      request(:put, params, path_with_id(id))
    end

    def self.delete(id)
      request(:delete, {}, path_with_id(id))
    end

    def self.search(params = {})
      request(:post, params, "#{default_path}/search")
    end

    def self.request(method, params, path = nil)
      raise 'You need to configure Infobase with your access_token.' unless Infobase.access_token

      path ||= default_path
      url = Infobase.base_url
      url += '/' unless url.last == '/'
      url += path

      case method
      when :post
        RestClient.post(url, params, authorization: "Bearer #{Infobase.access_token}", :timeout => -1) { |response, request, result, &block|
          handle_response(response, request, result)
        }
      when :put
        RestClient.put(url, params, authorization: "Bearer #{Infobase.access_token}", :timeout => -1) { |response, request, result, &block|
          handle_response(response, request, result)
        }
      else
        RestClient::Request.execute(:method => method, :url => url, :headers => {params: params, authorization: "Bearer #{Infobase.access_token}"}, :timeout => -1) { |response, request, result, &block|
          handle_response(response, request, result)
        }
      end
    end

    def self.handle_response(response, request, result)
      case response.code
      when 200..299
        json = Oj.load(response)
        if json[singular_name]
          new(json[singular_name])
        else
          json[plural_name] = json[plural_name].collect { |hash| new(hash) }
          json
        end
      when 400
        raise RestClient::BadRequest, response
      when 500
        raise RestClient::InternalServerError, response
      else
        puts response.inspect
        puts request.inspect
        raise result.inspect
      end
    end

    def self.default_path
      plural_name
    end

    def self.path_with_id(id)
      "#{default_path}/#{id}"
    end

  end
end


