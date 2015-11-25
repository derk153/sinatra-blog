require 'bundler'

# Setup load paths
Bundler.require(:default, :development)

# Just in development!
configure :development do
  use BetterErrors::Middleware
  # you need to set the application root in order to abbreviate filenames
  # within the application:
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

class Blog < Sinatra::Application
  get '/' do
    "Hello, World!"
  end
end
