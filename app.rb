require 'sinatra'
require 'sinatra/reloader'
require "sinatra/activerecord"
require "./models"

get '/' do
	'hello world'
end
