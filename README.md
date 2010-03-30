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
which illustrates proper usage.

Author
=========

Mike Perham, http://twitter.com/mperham, http://github.com/mperham, mperham AT gmail.com.