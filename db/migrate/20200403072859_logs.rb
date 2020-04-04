class Logs < ActiveRecord::Migration[6.0]
  def change
    create_table :logs do |t|
      t.string :title, null: false, default: ""
      t.references :player, foreign_key: true

      t.timestamps
    end
  end
end
