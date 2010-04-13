rack-fiber_pool
---------------

A Rack middleware component which runs each request in a Fiber from a pool of Fibers.

Requirements
==============

* Ruby 1.9
* thin 1.2.7

Usage
=======

Add a require and use statement to your Rack app.  See example/app.rb for a simple Sinatra app
which illustrates proper usage.  In general, you want the FiberPool to be inserted as early as
possible in the middleware pipeline.


Rails
========

You can see your app's current pipeline of Rack middleware using:

    rake middleware

Add Rack::FiberPool to your middleware in `config/environment.rb`:

    require 'rack/fiber_pool'
    Rails::Initializer.run do |config|
      config.middleware.use Rack::FiberPool
      config.threadsafe!
    end

If you do experience odd issues, make sure it appears as early in the pipeline as possible.  Anything
that sets/gets thread local variables (like the Rails' session) or performs I/O should be later in the pipeline.
For example, ActionController::Session::CookieStore does not work if it appears before Rack::FiberPool.

You can explicitly place the FiberPool like so:

    ActionController::Dispatcher.middleware.insert_before ActionController::Session::CookieStore, Rack::FiberPool


Author
=========

Mike Perham, http://twitter.com/mperham, http://github.com/mperham, mperham AT gmail.com.