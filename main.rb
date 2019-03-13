require "dotenv"
Dotenv.load

require "active_support/all"
require "byebug"
require "sinatra"
require "sinatra/reloader" if development?
require "redd/middleware"

Dir["./models/*.rb"].each { |model| require model }

use Rack::Session::Cookie, :key => "rack.session",
  :path => "/",
  :expire_after => 2592000,
  :secret => ENV["COOKIE_SECRET"]

use Redd::Middleware,
    user_agent:   "Redd:Username App:v1.0.0 (by /u/snoo_saver)",
    client_id:    ENV["REDDIT_CLIENT_ID"],
    secret:       ENV["REDDIT_SECRET"],
    redirect_uri: ENV["REDIRECT_URI"],
    scope:        %w(identity, history),
    via:          "/auth/reddit"

get "/" do
  if reddit_session
    listings = SavedHistory.new(reddit_session).all
    erb :home, locals: { listings: listings, name: reddit_session.me.name }
  else
    erb :sign_in
  end
end

get "/sample" do
  if reddit_session
    listings = SavedHistory.new(reddit_session).sample
    erb :home, locals: { listings: listings, name: reddit_session.me.name }
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

def reddit_session
  request.env["redd.session"]
end

