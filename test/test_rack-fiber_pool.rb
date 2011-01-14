require 'helper'

class TestRackFiberPool < MiniTest::Unit::TestCase

  def test_usage
    app = TestApp.new
    catch :async do
      res = Rack::MockRequest.new(Rack::FiberPool.new(app)).get("/")
    end
    assert_equal [200, {"Content-Type"=>"text/plain"}, ["Hello world!"]], app.result
  end

  def test_size
    app = TestApp.new
    catch :async do
      res = Rack::MockRequest.new(Rack::FiberPool.new(app, :size => 5)).get("/")
    end
    assert_equal [200, {"Content-Type"=>"text/plain"}, ["Hello world!"]], app.result
  end
  
  class TestApp
    attr_accessor :result
    def call(env)
      env['async.callback'] = proc { |result| @result = result }
      [200, {"Content-Type" => "text/plain"}, ["Hello world!"]]
    end
  end
end
