class CreateMovieArtists < ActiveRecord::Migration[5.2]
  def change
    create_table :movie_artists do |t|
      t.string :role
      t.belongs_to :movie
      t.belongs_to :artist
      t.timestamps
    end
  end
end
