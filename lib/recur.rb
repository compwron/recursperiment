RACK_ENV = ENV["RACK_ENV"] || "development"

require "bundler"
Bundler.require(:default, RACK_ENV)

require "sinatra/base"

module Recur
  class App < Sinatra::Base
    use Rack::Logger

    get "/heartbeat" do
      "recur-#{`git rev-parse HEAD`}"
    end

    post "/new" do
      logger.warn("Received new: #{_payload.inspect}")
      202
    end
  end
end
