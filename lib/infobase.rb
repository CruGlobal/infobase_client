require 'active_support/core_ext/string/inflections'
require 'infobase/base'

Dir[File.dirname(__FILE__) + '/infobase/*.rb'].each do |file|
  require file
end

module Infobase
  class << self
    attr_accessor :base_url, :access_token

    def configure
      yield self
    end

    def base_url
      @base_url ||= "https://infobase.uscm.org/"
    end

  end
end

