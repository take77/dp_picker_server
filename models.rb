class DpPokemon < ActiveRecord::Base
	has_many :logs through: :log_contents
	has_many :log_contents
end

class Player < ActiveRecord::Base
	has_many :logs
end

class Log < ActiveRecord::Base
	belongs_to :player
	has_many :log_contents
	has_many :dp_pokemons, through: :log_contents
end

class LogContents < ActiveRecord::Base
	belongs_to :log
	belongs_to :player
end
