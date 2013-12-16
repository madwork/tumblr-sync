require 'tumblr-sync/version'
require 'http'

module TumblrSync
  autoload :Tumblr,       'tumblr-sync/tumblr'
  autoload :Runner,       'tumblr-sync/runner'
  autoload :PhotoFetcher, 'tumblr-sync/photo_fetcher'
end
