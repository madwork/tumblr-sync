require 'optparse'
require 'thread'
require 'ruby-progressbar'

module TumblrSync
  class Runner
    CONCURRENCY = 12
    
    def initialize(arguments)
      @arguments = arguments
    end
    
    def run
      parse_options
      
      @concurrency ||= CONCURRENCY
      @tumblr = TumblrSync::Site.new(@arguments.last)
      @progress = ProgressBar.create(:format => '%a |%B| %c/%C - %p%%', :starting_at => 0, :total => @tumblr.total)
      
      FileUtils.mkdir_p(@tumblr.host)
      
      queue = Queue.new
      @tumblr.times do |i|
        Thread.new { queue << @tumblr.images(i*MAX, MAX) }
      end
      
      downloader = Thread.new do
        @tumblr.times do
          images = queue.pop
          images.each_slice(@concurrency).each do |group|
            threads = []
            group.each do |url|
              threads << Thread.new {
                begin
                  file = Mechanize::File.new(URI(url))
                  unless File.exists?("#{@tumblr.host}/#{file.filename}")
                    http = Mechanize.new
                    http.get(url) do |page|
                      filename = page.uri.path.split(/\//).last
                      next if File.exists?("#{@tumblr.host}/#{filename}")
                      page.save("#{@tumblr.host}/#{filename}")
                    end
                  end
                rescue Mechanize::ResponseCodeError
                ensure
                  @progress.increment
                end
              }
            end
            threads.each{ |thread| thread.join }
          end
        end
      end
      
      downloader.join
    end
    
    private
    
    def parse_options
      options = OptionParser.new
      options.banner = "Usage: #{$0} [options] [tumblr]"
      options.on('-c', '--concurrency NUMBER', "Specify concurrency option (Default: #{CONCURRENCY})") { |concurrency| @concurrency = concurrency.to_i }
      options.on('-h', '--help', "Show this message") { puts(options); exit }
      begin
        raise "Missing argument tumblr website" if ARGV.empty?
        options.parse!(@arguments)
      rescue => ex
        puts ex.message
        puts options
        exit
      end
    end
  end
end