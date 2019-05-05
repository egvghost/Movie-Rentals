class Artist < ApplicationRecord
  has_many :movie_artists
  has_many :movies, through: :movie_artists
end
