require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require 'sinatra/json'
require './models'
require 'sinatra/namespace'

require 'pry'

ActiveRecord::Base.establish_connection(
    adapter: 'sqlite3',
    database: './db/development.sqlite3'
)

before do
	response.headers['Access-Control-Allow-Origin'] = '*'
end

get '/' do
	'Hello world'
end

get '/party' do
	# FixMe: these cord are too bad to use
	if params[:base] == "true"
		base_tp = DpPokemon.where(base_id: 0)
	end

	if base_tp.present? && params[:legend] == "true"
		legend_tp = base_tp.legend(params[:legend])
	elsif params[:legend] == "true"
		legend_tp = DpPokemon.where(legend: false)
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

	if params[:weight] == "true"
		tp.each do |p|
			if p.weight = 2
				tp.push(p)
			end
		end
		binding.pry
	end

	party =
	if params[:mem_num]
		tp.sample(params[:mem_num])
	else
		tp.sample(6)
	end

	binding.pry

	json party
end
