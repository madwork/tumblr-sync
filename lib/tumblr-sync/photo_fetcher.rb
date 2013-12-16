module TumblrSync
  class PhotoFetcher
    def initialize(directory = ".")
      @directory = directory
    end

    def fetch(url)
      return if File.exists? filename = File.join(@directory, File.basename(URI.parse(url).path))
      File.open(filename, "wb") { |file| file.write(HTTP.get(url).response.body) }
    end
  end
end
