require 'sinatra'
require 'bcrypt'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require 'sinatra/json'
require 'sinatra/namespace'
require 'rack/cors'

require './models'

require 'pry'

ActiveRecord::Base.establish_connection(
    adapter: 'sqlite3',
    database: './db/development.sqlite3'
)

use Rack::Cors do
  allow do
    origins 'localhost:3000'

    resource '*', headers: :any,
        methods: [:get, :post, :delete, :put, :patch, :options, :head],
        credentials: true
  end
end

enable :sessions
set :session_store, Rack::Session::Pool

before do
	if session[:player_id]
		 @current_player = Player.find(session[:player_id])
	end
end

get '/party' do
	# FixMe: these cord are too bad to use

	if params[:base] == "true"
		base_tp = DpPokemon.where(base_id: 0)
	end

	if base_tp.present? && params[:legend] == "false"
		legend_tp = base_tp.where(legend: false)
	elsif params[:legend] == "false"
		DpPokemon.where(legend: false)
	elsif base_tp.present?
		legend_tp = base_tp
	end

	if legend_tp.present? && params[:only_dp] == "true"
		tp = legend_tp.where(weight: 2)
	elsif params[:only_dp] == "true"
		tp = DpPokemon.where(weight: 2)
	elsif legend_tp.present?
		tp = legend_tp
	end

	if tp.blank?
		tp = DpPokemon.all
	end

	if params[:useWeight] == "true"
		added_contents = tp.where(weight: 2)
		weight_tp = tp + added_contents
	else
		weight_tp = tp
	end

	party = weight_tp.sample(6)

	if params[:playerId]
		player = Player.find(params[:playerId].to_i)
		log =
		if params[:partyTitle].present?
			player.logs.create!(title: params[:partyTitle])
		else
			player.logs.create!(title: player.logs.count.to_s + "回目の選出")
		end

		party.each do |logcontent|
			LogContent.create(log: log, dp_pokemon: logcontent)
		end
	end

	json party
end

get '/logs' do
	player = Player.find(params[:playerId].to_i)
	logs = player.logs

	json logs
end

get '/log' do
	log = Log.find(params[:logId].to_i)
	party = log.dp_pokemons
	resBox = {log: log, party: party}

	json resBox
end

delete '/log' do
	log = Log.find(params[:logId].to_i)
	log.destroy
	player = Player.find(params[:playerId].to_i)
	logs = player.logs

	json logs
end

post '/sign_up' do
	player = Player.new(params)

	if player.save!
		session[:player_id] = player.id
		json({
			status: "created",
			logged_in: true,
			player: player
		})
	else
		json({ status: 500 })
	end
end

post '/sign_in' do
	player = Player.find_by(nickname: params[:nickname]).try(:authenticate, params[:password])

	if player
		session[:player_id] = player.id
		json({
			status: "get",
			logged_in: true,
			player: player
		})
	else
		json({ status: 401 })
	end
end

get '/logged_in' do
	if @current_player
		json({
			logged_in: true,
			player: @current_player
		})
	else
		json({
			logged_in: false
		})
	end
end


delete '/sign_out' do
	session.clear
	json({ status: 200, logged_in: false})
end
