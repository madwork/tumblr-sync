require 'optparse'
require 'fileutils'
require 'ruby-progressbar'
require 'thread'

module TumblrSync
  class Runner
    def initialize(arguments)
      @options = OptionParser.new
      @arguments = arguments
    end

    def run
      parse_options!

      tumblr = TumblrSync::Tumblr.new @arguments.last
      progress_bar = ProgressBar.create format: '%a |%B| %c/%C - %p%%', starting_at: 0, total: tumblr.total
      photo_fetcher = PhotoFetcher.new tumblr.host

      FileUtils.mkdir_p tumblr.host

      queue = Queue.new
      tumblr.times do |i|
        Thread.new { queue << tumblr.images(i*MAX, MAX) }
      end

      downloader = Thread.new do
        tumblr.times do
          images = queue.pop
          images.each_slice(10).each do |group|
            threads = []
            group.each do |url|
              threads << Thread.new {
                photo_fetcher.fetch url
                progress_bar.increment
              }
            end
            threads.each(&:join)
          end
        end
      end

      downloader.join
    rescue SocketError
      puts "Tumblr API not found!"
      puts @options
      exit
    end

    private

    def parse_options!
      @options.banner = "Usage: #{$0} [tumblr]"
      @options.on('-h', '--help', "Show this message") { puts(@options); exit }
      begin
        raise "Missing argument tumblr url" if @arguments.empty?
        @options.parse! @arguments
      rescue => ex
        puts ex.message
        puts @options
        exit
      end
    end
  end
end
