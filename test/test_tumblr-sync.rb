require 'minitest_helper'

class TestTumblrSync < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::TumblrSync::VERSION
  end
end
