require "csv"

CSV.foreach('db/csv/dp_seed.csv', headers: true) do |row|
	DpPokemon.create(
		name: row['name'],
		base_id: row['base_id'],
		legend: row['legend'],
		weight: row['weight']
		)
end
