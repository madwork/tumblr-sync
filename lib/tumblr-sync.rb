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
      (doc/'post photo-url').map{ |photo_url| photo_url.content if photo_url['max-width'].to_i == 1280 }.compact
    end
    
    def total
      response = @agent.get(@endpoint)
      doc = Nokogiri::XML.parse(response.body)
      (doc/'posts @total').first.value
    end
  end
end
