require 'forwardable'
require 'nokogiri'

module TumblrSync
  MAX = 50

  class Tumblr
    extend Forwardable

    attr_accessor :host

    def initialize(host)
      @host = host
    end

    def images(start, number = MAX)
      http = HTTP.get endpoint, params: { type: :photo, start: start, num: number }
      doc = Nokogiri::XML.parse http.response.body
      doc.xpath("//posts/post/photo-url[@max-width='1280']").map(&:text)
    end

    def total
      http = HTTP.get endpoint, params: { type: :photo }
      doc = Nokogiri::XML.parse http.response.body
      doc.xpath("//posts/@total").text.to_i
    end

    def times(&block)
      (total.to_f / MAX + 0.5).round.times(&block)
    end
    def_delegator :times, :count

    private

    def endpoint
      "http://#{host}/api/read"
    end
  end
end
