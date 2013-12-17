require 'mechanize'

module TumblrSync
  class PhotoFetcher
    def initialize(directory = ".")
      @directory = directory
    end

    def fetch(url)
      return if File.exists? File.join(@directory, Mechanize::File.new(URI(url)).filename)
      http = Mechanize.new
      http.get(url) do |page|
        return if File.exists? filename = File.join(@directory, File.basename(page.uri.path))
        page.save filename
      end
    end
  end
end
