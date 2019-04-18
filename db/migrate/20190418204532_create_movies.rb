class CreateMovies < ActiveRecord::Migration[5.2]
  def change
    create_table :movies do |t|
      t.string :name
      t.string :movie_url
      t.datetime :year
      t.string :parental_guidante_rate
      t.string :cover_url
      t.belongs_to :genre
      t.timestamps
    end
  end
end
