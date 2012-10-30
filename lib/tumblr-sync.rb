require 'mechanize'

module TumblrSync
  MAX = 50
  
  class Site
    attr_reader :host
    
    def initialize(host)
      @host = host
      @endpoint = "http://#{host}/api/read?type=photo"
    end
    
    def images(start, number = MAX)
      http = Mechanize.new
      http.get("#@endpoint&start=#{start}&num=#{number}")
      doc = Nokogiri::XML.parse(http.page.body)
      doc.xpath("//posts/post/photo-url[@max-width='1280']").map(&:text)
    end
    
    def total
      @total ||= begin
        http = Mechanize.new
        http.get(@endpoint)
        doc = Nokogiri::XML.parse(http.page.body)
        doc.xpath("//posts/@total").text.to_i
      end
    end
    
    def times(&block)
      (total.to_f / MAX + 0.5).round.times(&block)
    end
  end
end
