The new homepage is
[https://github.com/alebsack/rack-fiber_pool](https://github.com/alebsack/rack-fiber_pool)

rack-fiber_pool
---------------

A Rack middleware component which runs each request in a Fiber from a pool of Fibers.

Requirements
============

* Ruby 1.9
* EventMachine-based server (e.g. thin or rainbows)

Usage
=======

Add a require and use statement to your Rack app.  See example/app.rb for a simple Sinatra app
which illustrates proper usage.  In general, you want the FiberPool to be inserted as early as
possible in the middleware pipeline.

Options
=======

You may fix the pool size, otherwise it defaults to 100:

    use Rack::FiberPool, :size => 25

All exceptions raised by request handled within a fiber are rescued, by default returning a 500 with no body content. You may customize exceptions rescuing by providing a Proc object conforming to Rack's API:

    rescue_exception = Proc.new { |env, exception| [503, {}, exception.message] }
    use Rack::FiberPool, :rescue_exception => rescue_exception

Rails
=====

You can see your app's current pipeline of Rack middleware using:

    rake middleware

Add Rack::FiberPool to your middleware in `config/environment.rb`:

    require 'rack/fiber_pool'
    Rails::Initializer.run do |config|
      config.middleware.use Rack::FiberPool
      config.threadsafe!
    end

If you do experience odd issues, make sure it appears as early in the pipeline as possible.  Anything
that sets/gets thread local variables (like the Rails' session) or performs I/O should be later in the pipeline.  For example, ActionController::Session::CookieStore does not work if it appears before Rack::FiberPool.

You can explicitly place the FiberPool like so:

    ActionController::Dispatcher.middleware.insert_before ActionController::Session::CookieStore, Rack::FiberPool


Thanks to
==========

Eric Wong - for adding explicit support for Rack::FiberPool to rainbows.


Changes
==========

0.9.3 - fix incompatibility with sinatra streaming, new maintainer (alebsack)


Author
======

Mike Perham, [Twitter](http://twitter.com/mperham), [Github](http://github.com/mperham), mperham AT gmail.com.
