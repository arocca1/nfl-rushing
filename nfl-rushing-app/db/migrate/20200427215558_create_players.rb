class CreatePlayers < ActiveRecord::Migration[6.0]
  def change
    create_table :players do |t|
      t.string :name, null: false
    end
    add_reference :players, :team, foreign_key: true, null: false
    add_reference :players, :position, foreign_key: true, null: false
  end
end
