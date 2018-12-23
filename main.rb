require "dotenv"
Dotenv.load

require "sinatra"
require "sinatra/reloader" if development?
require "redd/middleware"

use Rack::Session::Cookie
use Redd::Middleware,
    user_agent:   "Redd:Username App:v1.0.0 (by /u/snoo_saver)",
    client_id:    ENV["REDDIT_CLIENT_ID"],
    secret:       ENV["REDDIT_SECRET"],
    redirect_uri: "http://localhost:4567/auth/reddit/callback",
    scope:        %w(identity),
    via:          "/auth/reddit"

get "/" do
  reddit = request.env["redd.session"]

  if reddit
    "Hello /u/#{reddit.me.name}! <a href='/logout'>Logout</a>"
  else
    "<a href='/auth/reddit'>Sign in with reddit</a>"
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
