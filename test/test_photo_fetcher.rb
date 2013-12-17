require 'minitest_helper'

describe TumblrSync::Tumblr do
  let(:fetcher) { TumblrSync::PhotoFetcher.new "tmp" }

  after { FileUtils.rm_rf "tmp" }

  describe "without redirect" do
    before do
      stub_request(:get, "foo.tumblr.com/tumblr.png").to_return(body: File.new('test/fixtures/tumblr.png'), status: 200)
      fetcher.fetch("http://foo.tumblr.com/tumblr.png")
    end

    it { fetcher.instance_variable_get('@directory').must_equal "tmp" }

    it "should fetch url" do
      File.read('test/fixtures/tumblr.png').must_equal File.read('tmp/tumblr.png')
      assert_requested :get, "http://foo.tumblr.com/tumblr.png", times: 1
    end

    it "should not fetch existing file" do
      fetcher.fetch("http://foo.tumblr.com/tumblr.png").must_be_nil
      assert_requested :get, "http://foo.tumblr.com/tumblr.png", times: 1
    end
  end

  describe "with redirect" do
    before do
      stub_request(:get, "foo.tumblr.com/picture-1234").to_return(headers: { 'Location' => 'http://foo.tumblr.com/tumblr.png' }, status: 301)
      stub_request(:get, "foo.tumblr.com/tumblr.png").to_return(body: File.new('test/fixtures/tumblr.png'), status: 200)
      fetcher.fetch("http://foo.tumblr.com/picture-1234")
    end

    it "should fetch url" do
      File.read('test/fixtures/tumblr.png').must_equal File.read('tmp/tumblr.png')
      assert_requested :get, "http://foo.tumblr.com/picture-1234", times: 1
      assert_requested :get, "http://foo.tumblr.com/tumblr.png", times: 1
    end

    it "should not save existing file" do
      fetcher.fetch("http://foo.tumblr.com/picture-1234").must_be_nil
    end
  end
end
