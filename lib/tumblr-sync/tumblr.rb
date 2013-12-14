module TumblrSync
  MAX = 50
  
  class Site
    extend Forwardable
    
    attr_reader :host
    
    # Example:
    # 
    # t = TumblrSync::Site.new("citieslight.tumblr.com") { |a| a.user_agent_alias = 'Mac Safari' }
    #
    def initialize(host, &block)
      @host = host
      @endpoint = "http://#{host}/api/read?type=photo"
      @mechaconf = block
    end
    
    def images(start, number = MAX)
      http = Mechanize.new(&@mechaconf)
      http.get("#@endpoint&start=#{start}&num=#{number}")
      doc = Nokogiri::XML.parse(http.page.body)
      doc.xpath("//posts/post/photo-url[@max-width='1280']").map(&:text)
    end
    
    def total
      @total ||= begin
        http = Mechanize.new(&@mechaconf)
        http.get(@endpoint)
        doc = Nokogiri::XML.parse(http.page.body)
        doc.xpath("//posts/@total").text.to_i
      end
    end
    
    def times(&block)
      (total.to_f / MAX + 0.5).round.times(&block)
    end

    def_delegator :times, :count
  end
end