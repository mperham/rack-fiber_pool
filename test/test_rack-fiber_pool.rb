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

  def test_exception
    app = TestBuggyApp.new
    catch :async do
      res = Rack::MockRequest.new(Rack::FiberPool.new(app)).get("/")
    end
    assert_equal [500, {}, ["Exception: I'm buggy! Please fix me."]], app.result
  end

  def test_custom_rescue_exception
    app = TestBuggyApp.new
    catch :async do
      rescue_exception = Proc.new { |env, exception| [503, {}, [exception.message]] }
      res = Rack::MockRequest.new(Rack::FiberPool.new(app, :rescue_exception => rescue_exception)).get('/')
    end
    assert_equal [503, {}, ["I'm buggy! Please fix me."]], app.result
  end

  class TestBuggyApp
    attr_accessor :result
    def call(env)
      env['async.orig_callback'] = proc { |result| @result = result }
      raise Exception.new("I'm buggy! Please fix me.")
    end
  end

  class TestApp
    attr_accessor :result
    def call(env)
      env['async.orig_callback'] = proc { |result| @result = result }
      [200, {"Content-Type" => "text/plain"}, ["Hello world!"]]
    end
  end
end
