require 'fiber_pool'

module Rack
  class FiberPool
    VERSION = '0.9.1'
    SIZE = 100

    # The size of the pool is configurable:
    #
    #   use Rack::FiberPool, :size => 25
    def initialize(app, options={})
      @app = app
      @fiber_pool = ::FiberPool.new(options[:size] || SIZE)
      @rescue_exception = options[:rescue_exception] || Proc.new { [500, {}, ""] }
      yield @fiber_pool if block_given?
    end

    def call(env)
      call_app = lambda do
        begin
          result = @app.call(env)
          env['async.callback'].call result
        rescue ::Exception => e
          env['async.callback'].call @rescue_exception.call(env, e)
        end
      end

      @fiber_pool.spawn(&call_app)
      throw :async
    end
  end
end
