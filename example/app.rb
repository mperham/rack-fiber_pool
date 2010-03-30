raise LoadError, "Ruby 1.9.1 only" if RUBY_VERSION < '1.9.1'

require 'rubygems'
require 'sinatra/base'
require 'fiber'

$LOAD_PATH << File.dirname(__FILE__) + '/../lib'

require 'rack/fiber_pool'

# rackup -s thin app.rb
# http://localhost:9292/test
class App < Sinatra::Base

  use Rack::FiberPool

  set :root, File.dirname(__FILE__)

  get '/test' do
    content_type "text/plain"
    body "Hello world from #{Fiber.current}"
  end

end