class ChangeDatetimeToDateInMovies < ActiveRecord::Migration[5.2]
  def up
    #change_column :table_name, :column_name, :new_type
    change_column :movies, :year, :date
  end

  def down
    change_column :movies, :year, :datetime
  end

end
