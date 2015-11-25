require 'bundler'
require_relative 'post'

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
  helpers do
    def get_posts
      posts = Dir.glob("posts/*.md").map do |post|
        post = post[/posts\/(.*?).md$/,1]
        Post.new(post)
      end
      # posts.reject! {|post| post.date > Date.today }
      posts.sort_by(&:date).reverse
    end
  end

  get '/' do
    haml :index
  end

  get '/blog' do
    get_posts
    # count = 10
    # @title = "Blog Archive"
    # @page = params[:page].to_i || 0
    # @max_page = latest_posts.count/count
    # @posts = latest_posts[(@page * count)..((@page * count) + count)]

    haml :blog
  end
end
