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
    def get_posts(category=nil)
      posts = Dir.glob("posts/*.md").map do |post|
        post = post[/posts\/(.*?).md$/,1]
        Post.new(post)
      end
      posts.sort_by(&:date).reverse

      posts.select{ |p| p.category == category } unless category.nil?
    end
  end

  get '/' do
    haml :index
  end

  get '/blog' do
    @posts = get_posts

    unless @posts.nil?
      haml :blog
    else
      halt 404
    end
  end

  get '/blog/:id' do
    @post = Post.new(params[:id])
    unless @post.title.nil?
      haml :post
    else
      halt 404
    end
  end

  get '/category/:name' do
    @posts = get_posts(params[:name])

    unless @posts.nil?
      haml :blog
    else
      halt 404
    end
  end

  not_found { haml :'404' }
end
