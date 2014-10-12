# test.rb
require File.expand_path '../../test_helper.rb', __FILE__

class MyTest < MiniTest::Unit::TestCase

  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_require_login
    get '/'
    follow_redirect!

    assert_equal "http://example.org/auth/meetup", last_request.url
    assert last_response.redirect?
    assert_match  "Redirecting to ", last_response.body
    #assert_equal "Hello, World!", last_response.body
  end
end
