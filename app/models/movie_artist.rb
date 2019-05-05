class MovieArtist < ApplicationRecord
  belongs_to :movie
  belongs_to :artist
end
