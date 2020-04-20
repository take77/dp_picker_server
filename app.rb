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
  ENV['DATABASE_URL'] )

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

	if params[:playerId]
		player = Player.find(params[:playerId].to_i)
	end

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

	if legend_tp.present? && params[:onlyDp] == "true"
		only_dp_tp = legend_tp.where(weight: 2)
	elsif params[:onlyDp] == "true"
		only_dp_tp = DpPokemon.where(weight: 2)
	elsif legend_tp.present?
		only_dp_tp = legend_tp
	end

	if only_dp_tp.blank?
		only_dp_tp = DpPokemon.all
	end

	if player && params[:pickedExcept]
		except_list = []

		player.logs.each do |log|
			pokemons = log.dp_pokemons
			except_list << pokemons.ids
		end

		tp =
		if except_list.present?
			only_dp_tp.where.not(id: except_list.flatten)
		else
			only_dp_tp
		end
	else
		tp = only_dp_tp
	end

	if params[:useWeight] == "true"
		weight_sum = 1
		rand_tp = {}

		tp.each do |pokemon|
			if pokemon.weight = 2
				rand_tp.store(weight_sum, pokemon.id)
				rand_tp.store(weight_sum + 1, pokemon.id)
				weight_sum += 2
			elsif pokemon.weight = 1
				rand_tp.store(weight_sum, pokemon.id)
				weight_sum += 1
			end
		end

		pick_id_list = []
		while pick_id_list.size < 6
			pick_id_tem = rand(1..weight_sum-1)
			pick_id = rand_tp[pick_id_tem]

			unless pick_id_list.include?(pick_id)
				pick_id_list.push(pick_id)
			end
		end

		party = tp.where(id: pick_id_list)
	else
		party = tp.sample(6)
	end

	if player
		log =
		if params[:partyTitle].present?
			player.logs.create!(title: params[:partyTitle])
		else
			logs_num = player.logs.count + 1
			player.logs.create!(title: logs_num.to_s + "種類目の選出")
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
		json({ status: 500, logged_in: false })
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
		json({ status: 401, logged_in: false})
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
