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
      response = Net::HTTP.get_response uri_endpoint(type: :photo, start: start, num: number)
      doc = Nokogiri::XML.parse response.body
      doc.xpath("//posts/post").map{|post| post.xpath(".//photo-url[@max-width='1280']").map { |url| url.text.strip }.uniq }
    end

    def total
      response = Net::HTTP.get_response uri_endpoint(type: :photo)
      doc = Nokogiri::XML.parse response.body
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

    def uri_endpoint(params = {})
      URI.parse(endpoint).tap do |uri|
        uri.query = URI.encode_www_form params
      end
    end
  end
end
