class CreateRentals < ActiveRecord::Migration[5.2]
  def change
    create_table :rentals do |t|
      t.datetime :valid_from
      t.datetime :valid_to
      t.references :user, foreign_key: true
      t.references :movie, foreign_key: true

      t.timestamps
    end
  end
end
