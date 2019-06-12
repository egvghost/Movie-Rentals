class AddActiveToMovies < ActiveRecord::Migration[5.2]
  def change
    add_column :movies, :active, :boolean
  end
end
