require 'fiber_pool'

module Rack
  class FiberPool
    SIZE = 100

    def initialize(app)
      @app = app
      @fiber_pool = ::FiberPool.new(SIZE)
      yield @fiber_pool if block_given?
    end

    def call(env)
      call_app = lambda do
        result = @app.call(env)
        env['async.callback'].call result
      end
      
      @fiber_pool.spawn(&call_app)
      throw :async
    end
  end
end