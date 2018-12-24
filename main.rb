require "dotenv"
Dotenv.load

require "byebug"
require "sinatra"
require "sinatra/reloader" if development?
require "redd/middleware"

use Rack::Session::Cookie, :key => "rack.session",
  :path => "/",
  :expire_after => 2592000,
  :secret => ENV["COOKIE_SECRET"]

use Redd::Middleware,
    user_agent:   "Redd:Username App:v1.0.0 (by /u/snoo_saver)",
    client_id:    ENV["REDDIT_CLIENT_ID"],
    secret:       ENV["REDDIT_SECRET"],
    redirect_uri: "http://localhost:4567/auth/reddit/callback",
    scope:        %w(identity, history),
    via:          "/auth/reddit"

get "/" do
  req = request.env["redd.session"]

  if req
    content = SavedContent.new(req)
    bookmarks = content.get_saved

    erb :home, locals: { bookmarks: bookmarks, name: req.me.name }
  else
    erb :sign_in
  end
end

get "/auth/reddit/callback" do
  redirect to("/") unless request.env["redd.error"]
  "Error: #{request.env["redd.error"].message} (<a href='/'>Back</a>)"
end

get "/logout" do
  request.env["redd.session"] = nil
  redirect to("/")
end


# client = reddit.client
# raw = client.request("get", "/user/#{reddit.me.name}/saved/")
# size = raw.body[:data][:children].size
class SavedContent
  PER_LISTING = 100

  attr_reader :request

  def initialize(request)
    @request = request
  end

  def get_saved
    bookmarks = []
    count = 0

    blob = get_blob
    while after = blob.body[:data][:after]
      puts "added after: #{after}"
      bookmarks << get_bookmarks(blob)
      count += PER_LISTING
      blob = get_blob(after, count)
    end

    puts "count: #{count}"
    bookmarks.flatten
  end

  private

  def get_bookmarks(blob)
    blob.body[:data][:children].collect { |bm| bm[:data] }
  end

  def get_blob(after=nil, count=0)
    # consider adding count param
    client.get(path, limit: PER_LISTING, after: after, count: count)
  end

  def path
    "/user/#{name}/saved/"
  end

  def client
    request.client
  end

  def name
    request.me.name
  end
end
