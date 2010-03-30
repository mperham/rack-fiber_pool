require 'fiber_pool'

module Rack
  # Run each request in a Fiber.  This FiberPool is
  # provided by em_postgresql.  Should probably split
  # this dependency out.
  class FiberPool
    def initialize(app)
      @app = app
      @fiber_pool = ::FiberPool.new
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