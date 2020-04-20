class DpPokemons < ActiveRecord::Migration[6.0]
  def change
    create_table :dp_pokemons do |t|
      t.string :name, null: false, default: ""
      t.string :image
      t.integer :base_id, null: false, default: 0
      t.boolean :legend, null: false, default: false
      t.integer :weight, null: false, default: 0

      t.timestamps
    end
  end
end
