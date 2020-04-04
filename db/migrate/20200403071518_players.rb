class Players < ActiveRecord::Migration[6.0]
  def change
    create_table :players do |t|
      t.string :nickname, null: false, default: ""
      t.string :password_digest, null: false, default: ""

      t.timestamps
    end
  end
end
