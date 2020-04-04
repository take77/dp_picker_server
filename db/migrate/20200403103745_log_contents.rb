class LogContents < ActiveRecord::Migration[6.0]
  def change
    create_table :log_contents do |t|
      t.references :log, foreign_key: true
      t.references :dp_pokemon, foreign_key: true

      t.timestamps
    end

    add_index :log_contents, [:log_id, :dp_pokemon_id], unique: true
  end
end
