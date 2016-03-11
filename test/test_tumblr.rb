require 'minitest_helper'

describe TumblrSync::Tumblr do
  let(:tumblr) { TumblrSync::Tumblr.new "foo.tumblr.com" }

  it { TumblrSync::MAX.must_equal 50 }

  it "should get host" do
    tumblr.host.must_equal "foo.tumblr.com"
  end

  it "should get endpoint" do
    tumblr.send(:endpoint).must_equal "http://foo.tumblr.com/api/read"
  end

  it "should update host" do
    tumblr.host = "bar.tumblr.com"
    tumblr.host.must_equal "bar.tumblr.com"
  end

  it "should update endpoint" do
    tumblr.host = "bar.tumblr.com"
    tumblr.send(:endpoint).must_equal "http://bar.tumblr.com/api/read"
  end

  it "should get array of images" do
    stub_request(:get, "foo.tumblr.com/api/read").with(query: { type: :photo, start: 0, num: 10 }).to_return(body: File.new('test/fixtures/api.xml'), status: 200)
    tumblr.images(0, 10).must_equal [
      ["http://24.media.tumblr.com/tumblr_mebokdGrmq1rjwt7po1_500.jpg"],
      ["http://25.media.tumblr.com/tumblr_mebojvwCIb1rjwt7po1_500.jpg"],
      ["http://40.media.tumblr.com/7bf3bc523a3c0f99ad095bb048ec7f05/tumblr_nlvyfb7Fm41r3bmeoo1_1280.jpg",
       "http://36.media.tumblr.com/4904f4db02d987c12b215a2845a7294b/tumblr_nlvyfb7Fm41r3bmeoo3_1280.jpg",
       "http://40.media.tumblr.com/24070cfbdeed18e81b025b1fa76c5ccd/tumblr_nlvyfb7Fm41r3bmeoo2_1280.jpg"],
    ]
  end

  it "should get total of images" do
    stub_request(:get, "foo.tumblr.com/api/read").with(query: { type: :photo }).to_return(body: File.new('test/fixtures/api.xml'), status: 200)
    tumblr.total.must_equal 2721
  end

  it "should get cycles to retrieve all pictures" do
    stub_request(:get, "foo.tumblr.com/api/read").with(query: { type: :photo }).to_return(body: File.new('test/fixtures/api.xml'), status: 200)
    tumblr.times.must_be_instance_of Enumerator
    tumblr.count.must_equal 55
  end

  it "should get the uri endpoint" do
    tumblr.send(:uri_endpoint).must_equal URI("http://foo.tumblr.com/api/read?")
    tumblr.send(:uri_endpoint, { type: :photo }).must_equal URI("http://foo.tumblr.com/api/read?type=photo")
  end
end
