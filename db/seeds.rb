require "csv"
require 'carrierwave'
require 'carrierwave/orm/activerecord'

CSV.foreach('db/csv/dp_seed.csv', headers: true) do |row|
	pokemon = DpPokemon.create(
		name: row['name'],
		base_id: row['base_id'],
		legend: row['legend'],
		weight: row['weight']
		)

	pokemon.image = open("db/images/#{pokemon.id}.png")
	pokemon.save
end
