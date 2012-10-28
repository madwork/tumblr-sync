require 'mechanize'

module TumblrSync
  class Site
    attr_reader :agent, :host
    
    def initialize(host)
      @host = host
      @endpoint = "http://#{host}/api/read?type=photo"
      @agent = Mechanize.new
    end
    
    def images(start, number = 50)
      response = @agent.get("#@endpoint&start=#{start}&num=#{number}")
      doc = Nokogiri::XML.parse(response.body)
      doc.xpath("//posts/post/photo-url[@max-width='1280']").map(&:text)
    end
    
    def total
      response = @agent.get(@endpoint)
      doc = Nokogiri::XML.parse(response.body)
      doc.xpath("//posts/@total").text.to_i
    end
  end
end
