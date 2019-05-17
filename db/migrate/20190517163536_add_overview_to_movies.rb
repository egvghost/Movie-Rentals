class AddOverviewToMovies < ActiveRecord::Migration[5.2]
  def change
    add_column :movies, :overview, :string
  end
end
