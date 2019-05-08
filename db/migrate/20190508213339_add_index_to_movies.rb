class AddIndexToMovies < ActiveRecord::Migration[5.2]
  def change
    add_index :movies, [:name, :release_date], unique: true
  end
end
