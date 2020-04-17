require 'bcrypt'

class DpPokemon < ActiveRecord::Base
	has_many :logs, through: :log_contents
	has_many :log_contents, dependent: :destroy
end

class Player < ActiveRecord::Base
	has_many :logs, dependent: :destroy

	validates :nickname, presence: true
	validates :password_digest, presence: true

	has_secure_password
end

class Log < ActiveRecord::Base
	belongs_to :player
	has_many :log_contents, dependent: :destroy
	has_many :dp_pokemons, through: :log_contents

	validates :title, presence: true
	validates :player_id, presence: true
end

class LogContent < ActiveRecord::Base
	belongs_to :log
	belongs_to :dp_pokemon

	validates :log_id, presence: true, uniqueness: {scope: :dp_pokemon_id}
	validates :dp_pokemon_id, presence: true
end
