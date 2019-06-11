class Movie < ApplicationRecord
  belongs_to :genre
  has_many :movie_artists, dependent: :destroy
  has_many :artists, through: :movie_artists
  validates :name, uniqueness: { scope: :release_date,  message: "Movie already exists" }
  has_many :rentals
  has_many :users, through: :rentals
  paginates_per 28

  def self.permited (user_age)
    movies = case 
      when user_age < 13 then Movie.where(rating: ["", "G", "PG"])
      when user_age < 17 then Movie.where(rating: ["", "G", "PG", "PG-13"])
      else Movie.all
    end
  end

  def self.import_movie_from_tmdb(tmdb_id)
    tmdb_movie = Tmdb::Movie.detail(tmdb_id)
    tmdb_movie_genre = tmdb_movie["genres"].first["name"]
    tmdb_movie_rating = Tmdb::Movie.releases(tmdb_id)
    movie_genre = Genre.find_or_create_by(name: tmdb_movie_genre)
    movie_credits = Tmdb::Movie.credits(tmdb_id) 
    movie = self.new
    movie.name = tmdb_movie["title"]
    movie.overview = tmdb_movie["overview"]
    movie.genre = movie_genre
    movie.release_date = tmdb_movie["release_date"]
    movie.cover_url = "https://image.tmdb.org/t/p/w400/#{tmdb_movie["poster_path"]}"
    movie.rating = tmdb_movie_rating["countries"].find{|c| c["iso_3166_1"] == "US"}["certification"]
    movie.save
    #byebug
    self.import_directors_from_tmdb movie_credits, movie
    self.import_producers_from_tmdb movie_credits, movie 
    self.import_cast_from_tmdb movie_credits, movie
    movie
  end

  def directors 
    self.movie_artists.where(role: "Director")
  end

  def cast
    self.movie_artists.where(role: "Cast")
  end

  def producers 
    self.movie_artists.where(role: "Producer")
  end
  

  private

  def self.import_directors_from_tmdb(movie_credits, movie)
    directors = movie_credits["crew"].select{|c| c["job"] == "Director"} 
    directors.each do |d|
      artist = Artist.find_or_create_by(name: d["name"])
      MovieArtist.find_or_create_by(role: "Director",movie: movie, artist: artist)
    end
  end

  def self.import_producers_from_tmdb(movie_credits, movie)
    producers = movie_credits["crew"].select{|c| c["job"] == "Producer" || c["job"] == "Executive Producer"}
    producers.each do |p|
      artist = Artist.find_or_create_by(name: p["name"])
      MovieArtist.find_or_create_by(role: "Producer",movie: movie, artist: artist)
    end 
  end

  def self.import_cast_from_tmdb(movie_credits, movie)
    cast = movie_credits["cast"]
    cast.each do |c|
      artist = Artist.find_or_create_by(name: c["name"])
      MovieArtist.find_or_create_by(role: "Cast",movie: movie, artist: artist)   
    end
  end

end
